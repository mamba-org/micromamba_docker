default_mamba_user="mambauser"
altered_mamba_user="MaMbAmIcRo"

setup_file() {
    load 'test_helper/common-setup'
    _common_setup
    docker build --quiet \
                 --tag=different-user \
                 --build-arg=MAMBA_USER=$altered_mamba_user \
		 --file=${PROJECT_ROOT}/Dockerfile \
		 "$PROJECT_ROOT" > /dev/null
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "docker run --rm  micromamba:test whoami" {
    run docker run --rm  micromamba:test whoami
    assert_output "$default_mamba_user"
}

@test "docker run --rm  different-user whoami" {
    run docker run --rm  different-user whoami
    assert_output "$altered_mamba_user"
}

@test "docker run --rm  --user=1001:1001 micromamba:test whoami" {
    run docker run --rm  --user=1001:1001 micromamba:test whoami
    assert_output 'whoami: cannot find name for user ID 1001'
}

@test "docker run --rm  --user=root micromamba:test whoami" {
    run docker run --rm  --user=root micromamba:test whoami
    assert_output 'root'
}

@test "docker run --rm  --user=0:0 micromamba:test whoami" {
    run docker run --rm  --user=0:0 micromamba:test whoami
    assert_output 'root'
}

@test "docker run --rm  micromamba:test /bin/bash -c 'realpath ~'" {
    run docker run --rm  micromamba:test /bin/bash -c 'realpath ~'
    assert_output "/home/$default_mamba_user"
}

@test "docker run --rm  different-user /bin/bash -c 'realpath ~'" {
    run docker run --rm  different-user /bin/bash -c 'realpath ~'
    assert_output "/home/$altered_mamba_user"
}

@test "docker run --rm  --user=1001:1001 micromamba:test /bin/bash -c 'realpath ~'" {
    run docker run --rm  --user=1001:1001 micromamba:test /bin/bash -c 'realpath ~'
    assert_output "/home/$default_mamba_user"
}

@test "docker run --rm  --user=root micromamba:test /bin/bash -c 'realpath ~'" {
    run docker run --rm  --user=root micromamba:test /bin/bash -c 'realpath ~'
    assert_output '/root'
}

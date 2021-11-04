import React, { Component } from 'react'
import { Form, Input, Button, Radio } from 'antd'
import { Link } from 'react-router-dom'
import axios from 'axios'


export default class ForgetPSW extends Component {
    constructor() {
        super();
        this.state = {
            username: "",
            IDcard: "",
            type: ""
        };
    }
    onFinish = (values) => {
        this.setState({
            type: usertype
        })
        /*
        if (this.state.type === 1) {
            this.props.history.push({ pathname: '/StudentCenter/StudentInfo', state: { username: name, psw: passw } });
        }
        else if (this.state.type === 2) {
            this.props.history.push({ pathname: '/TeacherCenter/TeacherInfo', state: { username: name, psw: passw } });
        }
        else if (this.state.type === 3) {
            this.props.history.push({ pathname: '/ManagerCenter/ManagerInfo', state: { username: name, psw: passw } });
        }*/
        const id = this.state.username;
        const idcard = this.state.idcard;
        const type = this.state.type;
        console.log(type);
        axios
            .post('http://127.0.0.1:8000/api/findpsw',
                transformFormData({
                    id: id,
                    IDcard: idcard,
                    type: type
                }),
                {
                    headers: { 'content-type': 'application/x-www-form-urlencoded' }
                }
            ).then((response) => {
                // get response
                console.log(response);

                const code=response.data.code;

                var psw = response.data.data;
                console.log(psw);
                if (code === 200) {
                    alert('您的密码：'+psw);                    
                }
                else{
                    alert('身份验证失败，拒绝找回密码请求');
                }

            }).catch(function (error) {
                alert('身份验证失败，拒绝找回密码请求');
              })

    };

    nameChange = (e) => {
        let value = e.target.value;
        this.setState({
            username: value
        })
    }

    cardChange = (e) => {
        let value = e.target.value;
        console.log(value);
        this.setState({
            idcard: value
        })
    }

    render() {
        const { username } = this.state;
        const { idcard } = this.state;
        return (
            <div className="login">
                <div className="login-content-wrap">
                    <div className="login-content">
                        <img className="logo" src="resources/logo.png" />

                        <div id="body" className="login-from">
                            <Form
                                initialValues={{ remember: true }}
                                onFinish={this.onFinish}>
                                <Form.Item name="username" rules={
                                    [
                                        { required: true, message: '请输入用户名！' }
                                    ]
                                }>
                                    <Input value={username} onChange={this.nameChange} placeholder="用户名" />
                                </Form.Item>

                                <Form.Item name="IDcard" rules={
                                    [
                                        { required: true, message: '请输入身份证号！' },

                                    ]
                                }>
                                    <Input value={idcard} onChange={this.cardChange} type="password" placeholder="身份证号" />
                                </Form.Item>


                                <Choose></Choose>

                                <Form.Item>
                                    <br />
                                    <Button className="login-form-button" htmlType="submit" type="primary" shape="round" size='large'>
                                        找回
                                    </Button>
                                </Form.Item>
                                <Form.Item>
                                    <Link to="/LoginInterface">
                                        <Button className="login-form-button" type="primary" shape="round" size='large'>
                                            返回登录
                                        </Button>
                                    </Link>
                                </Form.Item>

                            </Form>
                        </div>
                    </div>
                </div>
            </div>
        )
    }
}

var usertype = 1;

const Choose = () => {
    const [value, setValue] = React.useState(1);

    const onChange = e => {
        usertype = e.target.value;
        console.log(usertype);
        console.log('radio checked', e.target.value);
        setValue(e.target.value);

    };

    return (
        <Radio.Group onChange={onChange} value={value} style={{ marginLeft: 30 }}>
            <Radio name="choice" value={1} >学生</Radio>
            <Radio name="choice" value={2}>教师</Radio>
            <Radio name="choice" value={3}>管理员</Radio>
        </Radio.Group>
    );
};


const transformFormData = (obj) => {
    let formData = new FormData()

    for (let k in obj) {
        formData.append(k, obj[k])
    }

    return formData
}


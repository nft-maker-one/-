# ECDSA（Elliptic Curve Digital Signature Algorithm）椭圆曲线签名算法
## 函数签名
当metamask小狐狸钱包要获得授权，对我们地址里面的token进行某笔操作时，往往需要首先获得我们私钥签署得到的函数签名。那么通过私钥和交易hash，是如何生成函数签名的呢
？在以太坊中，我们采用了ECDSA算法来完成这一签名过程

## 椭圆曲线
椭圆曲线的一般形式为y=x^3+a*x+b(且

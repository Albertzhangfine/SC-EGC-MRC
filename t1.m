%发射天线为1根，接收天线为5根
%分别采用选择合并、等增益合并、最大比合并方式
clear                                          
clc
%% 调制
%生成k个随机数列的bpsk信号作为初始信号
k=500000;
%最大信噪比为snr_max
snr_max=25;
x=round(rand(1,k));

%bpsk调制
h=pskmod(x,2);  
bpsk=real(h);
%% 传输
for snr=1:1:snr_max
    
    %给信号乘上参数B=1/sqrt(2)的瑞利衰落系数
    %四根接受天线相当于该过程独立进行4次
    
    R1=raylrnd(1/sqrt(2),1,k);
    R2=raylrnd(1/sqrt(2),1,k);
    R3=raylrnd(1/sqrt(2),1,k);
    R4=raylrnd(1/sqrt(2),1,k);
    R5=raylrnd(1/sqrt(2),1,k);
    
    h1=R1.*bpsk;
    h2=R2.*bpsk;
    h3=R3.*bpsk;
    h4=R4.*bpsk;
    h5=R5.*bpsk;
    
    %给信号加上功率为snr（db）的高斯白噪声信号
    
    x1=awgn(h1,snr);
    x2=awgn(h2,snr);
    x3=awgn(h3,snr);
    x4=awgn(h4,snr);
    x5=awgn(h5,snr);
    
    %选择合并
    %选择每一时刻信号和噪声功率之和最大的信号
    xx1=abs(x1);
    xx2=abs(x2);
    xx3=abs(x3);
    xx4=abs(x4);
    xx5=abs(x5);
    aa=max(max(max(xx1,xx2),max(xx3,xx4)),xx5);
    y1=(aa==xx1).*x1+(aa==xx2).*x2+(aa==xx3).*x3+(aa==xx4).*x4+(aa==xx5).*x5;
    
    %等增益合并
    y2=(x1+x2+x3+x4+x5)/5;
    
    %最大比合并
    y3=conj(R1).*x1+conj(R2).*x2+conj(R3).*x3+conj(R4).*x4+conj(R5).*x5;
    

    %% 解调
    yy1=pskdemod(y1,2);
    yy2=pskdemod(y2,2);
    yy3=pskdemod(y3,2);
    
    [bit_y1,~]=biterr(x,yy1);
    [bit_y2,~]=biterr(x,yy2);
    [bit_y3,~]=biterr(x,yy3);

    %计算误码率
    ber1(snr)=bit_y1/k;
    ber2(snr)=bit_y2/k;
    ber3(snr)=bit_y3/k;
    
end
%% 作图
figure
snr=1:1:snr_max;
semilogy(snr,ber1);
hold on
semilogy(snr,ber2);
hold on
semilogy(snr,ber3);
legend('选择性合并','等增益合并','最大比合并')
title('BER for 1tx & 5rx')
xlabel('SNR')
ylabel('BER')

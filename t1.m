%��������Ϊ1������������Ϊ5��
%�ֱ����ѡ��ϲ���������ϲ������Ⱥϲ���ʽ
clear                                          
clc
%% ����
%����k��������е�bpsk�ź���Ϊ��ʼ�ź�
k=500000;
%��������Ϊsnr_max
snr_max=25;
x=round(rand(1,k));

%bpsk����
h=pskmod(x,2);  
bpsk=real(h);
%% ����
for snr=1:1:snr_max
    
    %���źų��ϲ���B=1/sqrt(2)������˥��ϵ��
    %�ĸ����������൱�ڸù��̶�������4��
    
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
    
    %���źż��Ϲ���Ϊsnr��db���ĸ�˹�������ź�
    
    x1=awgn(h1,snr);
    x2=awgn(h2,snr);
    x3=awgn(h3,snr);
    x4=awgn(h4,snr);
    x5=awgn(h5,snr);
    
    %ѡ��ϲ�
    %ѡ��ÿһʱ���źź���������֮�������ź�
    xx1=abs(x1);
    xx2=abs(x2);
    xx3=abs(x3);
    xx4=abs(x4);
    xx5=abs(x5);
    aa=max(max(max(xx1,xx2),max(xx3,xx4)),xx5);
    y1=(aa==xx1).*x1+(aa==xx2).*x2+(aa==xx3).*x3+(aa==xx4).*x4+(aa==xx5).*x5;
    
    %������ϲ�
    y2=(x1+x2+x3+x4+x5)/5;
    
    %���Ⱥϲ�
    y3=conj(R1).*x1+conj(R2).*x2+conj(R3).*x3+conj(R4).*x4+conj(R5).*x5;
    

    %% ���
    yy1=pskdemod(y1,2);
    yy2=pskdemod(y2,2);
    yy3=pskdemod(y3,2);
    
    [bit_y1,~]=biterr(x,yy1);
    [bit_y2,~]=biterr(x,yy2);
    [bit_y3,~]=biterr(x,yy3);

    %����������
    ber1(snr)=bit_y1/k;
    ber2(snr)=bit_y2/k;
    ber3(snr)=bit_y3/k;
    
end
%% ��ͼ
figure
snr=1:1:snr_max;
semilogy(snr,ber1);
hold on
semilogy(snr,ber2);
hold on
semilogy(snr,ber3);
legend('ѡ���Ժϲ�','������ϲ�','���Ⱥϲ�')
title('BER for 1tx & 5rx')
xlabel('SNR')
ylabel('BER')

From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Subject: Re: fix corrupted thin pool
Date: Sun, 26 Oct 2014 00:53:04 +0400
Message-ID: <CACaajQtQ+h2NBhiH=Y-zET1cK7PE=5=PFoeSgLQqwnr9PiY0Cw@mail.gmail.com>
References: <CACaajQsU_z8pwUGMHfD1y2dVkP_gKgajM6bBV1wFpxpF_7m1nA@mail.gmail.com>
	<544B9ADD.6040607@redhat.com>
	<CACaajQsG+2hPqp93yU77TBTOwy2EA_zHbV=pNqiq8dpsqPXzfw@mail.gmail.com>
	<544C05A2.8090004@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a1132ee84d1ff5d0506457cf9
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <544C05A2.8090004@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: LVM <linux-lvm@redhat.com>
List-Id: dm-devel.ids

--001a1132ee84d1ff5d0506457cf9
Content-Type: text/plain; charset=UTF-8

2014-10-26 0:18 GMT+04:00 Zdenek Kabelac <zkabelac@redhat.com>:
> There is 'internal' metadata archive then -
>
> dd if=/dev/your_pv_volume  of=/tmp/1st.megabyte   bs=1M count=1
>
> It's will capture first megabyte of your PV where are embedded
> metadata of your Volume group.
>
> If you are not skilled enough - tar.gz and send this file to me.


I'm do dd and send it. While i'm break thin pool i'm try to restore volume 2657.
But i don't stop lvm thin pool =(.

-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru

--001a1132ee84d1ff5d0506457cf9
Content-Type: application/x-gzip; name="sdb.tar.gz"
Content-Disposition: attachment; filename="sdb.tar.gz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1pg14v20

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
6j8yj8wj88g8Mo/MI/PIPDKPzNN1yZB5ZB6ZR+aZxWrVf2L9R//pXf+pp/75n2+jpzKkDM2jDCkc
CofCoXAsKRwKh8KhcCgcXRSOfBQNunA0o8PZwvHLRXedJqw5rFb9J9F/9J9h9R+VR+VReVQelUfl
UXlUHpVH5VF5VB6VxxriatV/Uv1H/+lb/2mGqyl9/uf4wo//ZM2s/neW5n/5GJBAJBAJRAKRQCQQ
CUSXDETfjhM/z6M7r59vp2El3ozDw+X4dSg/PRiHL9nW8/CuvP063F7/tPdyZb77VsdVUidd7dup
l/tf3yCbzftLZ9PZdLaed7a9w5PkVC1F6ShLRlEy2M528lp51NkuvOiuQ88Fq1X/yfQf/WdY/Ufe
kXfkHXlH3pF35B15R96Rd3pWMOQdeUfekXemslr1n1z/0X9613/i6T//J/bBH2VobmVI9pA9ZA/Z
Q/YYevbQOXQOnWPBOsdgv7/95MUxPbdz+P72Ya5W/afQf/SfYfUflUflUXlUHpVH5VF5VB6VR+VR
eVQelcca4mrVf0r9R//pXf9Jpv/8n2YO/TvLYs//EYgEIoFIIBKIBCKBaKqB6NsZ48e+ja/8+2Xl
fVh9kj8Pj6482g7PlqNb4dba9mGIX7zfD/f21lceP5rzviVJXVYd/TvN4sl9K39512w2z11jOpvO
du4O9bKzxcUoS4fc2U5eKyc726mL7rr+tOw/lf6j/wyr/8g78o68I+/IO/KOvCPvyDtzO2jIO0vy
jrzz+zsk78g7l12t+k+t/+g/ves/6fSf/5P64I8ypAz1qAzJHrKH7CF7DDB76Bw6h86hc+gc1sxX
m/5TR/qP/jOs/qPyqDwqj8qj8qg8Ko/Ko/KoPD3bHJVH5VF5rKmsVv0n1n/0n971n2z6n//JfP5H
GVKGelSGFA6FQ+FQOBZ1iFc4FI7uC8d6M7sdDftp1LyxjqJoFOWDLRxplRdR3vzwiy+662G8g9Vq
/k/M/+b/Yc3/pnxTvinflG/KN+Wb8k35pnxTvinflD/U1Wr+T83/5v/ezf/59P0/5//KgDLQozJg
wjXhmnC7H+JMuCbcfk24xShOR1E22Am3GSXKKjs14U5e9Lzmv8z8Z/4b1vxnyjPlmfJMeaY8U54p
z5RnyjPlLf6UN6P5Lzf/mf96N/8V0/e/gv+ZDE2GPZoMTTgmHBOOCWdYE87G4XhpfXywtJQsReko
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
P43huB50dMYsTr3Zlec/jUFqlVql1sVJrdmwU2t2bmrNFj619nK167+F/qv/Dqv/qrvqrrqr7qq7
6q66q+6qu+quuqvuqrt9ynPqrrqr7qq7VsvVrv+W+q/+q//qv/qv/qv/6r/6r/6r/+q/+u9/999a
/9V/9V/9t6ebo/920H+LURwN+vufyjw6/f1Ppy666xz6x612/bfSf/Xf3vXfbAbPf8jz+O8y8vwH
hVghVogVYoVYIVaIFWKFWCFWiBe7EH8fbn5s5I3Pb7Z3yvBl+9/dsLyXvw47y2tb4daVzx/Cq4f3
n4Y3aw+/7q7MeSOPhpyio1NDceodsfp1I5vdk9qldqn93B3qT2rf2Ds8qc7FUhSPknjIzyw+ebFs
fvjFFz2N/lvrv/rvsPqvuqvuqrvqrrqr7qq76q66q+6qu+quuqvuqrvqrrqr7v7Y2b7X3Rl//jeL
9F/9t3f9N5/W5393xvvj48//Vj72KwzPLwyrnqqn6ql6qp6qp+qpeqqequccqqfKqXKqnAtWOYf7
uODjF8fs3MrpccHTWu36b6z/6r/D6r8yr8wr88q8Mq/MK/PKvDKvzHv5PZJ5ZV6Zd4FKpswr88q8
Mu+fstr130T/1X9713+LqX/+tzl++gCwMqwMK8PKsDKsDCvDyvB/7JEyfOkyLGgKmoKmoDnYoBnn
oygaRcP9mrMsL5Monwyapy666+r3c7Xrf6n+p/8Nq/+pfCqfyqfyqXwqn8qn8ql8Kt/l90jlU/lU
PpVP5VP5erna9b9M/9P/etf/yml9/u/4wo//ZN9v2PnL5wAVQoVQIVQIFUKFUCFUCBVChbBHhfDM
rfW7K7trD8ch/Xi4Hq59zsbhxv7elVBffXw9XN14th5uHazc2nwz7407qgcdvboXxeTG1effWi+1
Sq1S6+Kk1mLYqbU4N7UWC5Rae7na9d9c/9V/h9V/1V11V91Vd9VddVfdVXfVXXX38nuk7qq76u4C
BUx1V91Vd9XdP2W167+F/qv/9q7/VjP4/G9VlT77qw6rw+qwOqwOq8PqsDqsDqvD6vAA6/DRuPPz
+L7x5uWzw5C+3vwcXm1ufwxPHjxNwnq8/zQ8fnjtWTjYef/16e9/N9nv7VmV1UnbcfOye1ZO7FkS
KegKuoK+MAU9SUZZMorq4Rb04xfHyYJ+6qJn1H9L/Vf/HVb/VXgVXoVX4VV4FV6FV+FVeBXey++R
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
EAA=
--001a1132ee84d1ff5d0506457cf9
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--001a1132ee84d1ff5d0506457cf9--

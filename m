From: "C'est Pierre" <cestpierre@gmail.com>
Subject: Setting up multipath device
Date: Thu, 8 Jun 2006 14:47:57 +0100
Message-ID: <5485940d0606080647k1fc84114i2c36537008723974@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

I am trying to setup a multipath device, but I am failing to do so,
cuz I don't have as much documentation as I would wish to.

Here's the output of 'multipath -l'

# multipath -l
3600508b40010130d00006000011c0000
[size=50 GB][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][enabled]
 \_ 0:0:0:2 sda 8:0   [active][undef]
 \_ 1:0:0:2 sdb 8:16  [active][undef]

How can I generate a "one device" that's recognizable by lvm, just so
I can setup a VG with it?

Thank you
Pierre

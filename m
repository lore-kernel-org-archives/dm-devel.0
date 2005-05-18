From: gowda_avinash@emc.com
Subject: multipathing on SuSe9
Date: Wed, 18 May 2005 09:47:04 +0100
Message-ID: <50C05B7AA7D6924FB5E384EF14BC647BC4534F@inba1mx2.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
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

Hi: 

I am running device mapper version 1.00.21 multipath-tools 0.4.3-pre6,
kernel 2.6.11-rc3. 
I am getting the following errors when I run multipath -v2 

create: 00001826001580CF
[size=2 MB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
  \_ 2:0:0:23 sdaa 65:160  [ready ]
  \_ 2:0:1:23 sday 67:32   [ready ]

device-mapper ioctl cmd 9 failed: Invalid argument
device-mapper ioctl cmd 14 failed: No such device or address

I am able to do I/O to the device. These messages are found under
lib/ioctl/libdm-iface.c 

Anything that I am missing? 

TIA,
avinash

From: Doug Dumitru <doug@easyco.com>
Subject: dm-ramdisk module
Date: Thu, 17 Dec 2009 23:37:54 -0800
Message-ID: <4B2B3152.8090207@easyco.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

Alasdair Kergon,

The MAINTAINERS file shows you as the person with responsibility for 
device-mapper functions.  Hopefully you are the correct person to contact.

I have developed a high-performance ramdisk device-mapper module and 
wanted to see if there was any interest in it.

In doing work with another proprietary driver, I needed a very fast 
block device to test and tune against.  The system boot ramdisk seemed 
difficult to use and also seems to suffer performance issues when 
hammered on multiple threads.  Based on the dm-zero module, and the work 
that I have been doing, throwing together a dm-ramdisk module was pretty 
easy.

Do you think there is any interest in this module in the main-line 
kernel or as a teaching tool for device-mapper programmers.  If so I 
would be happy to contribute it.

* In it's current state it is functional on 32-bit and 64-bit x86 kernels.

* It compiles and runs on 2.6.9 thru 2.6.30.

* It will probably work on non-x86 platforms, but needs to be audited to 
make sure all memory primitives are correct (things like KMAP_ATOMIC usage).

* The source probably needs to be adjusted for source code style, 
indenting, etc. to match the rest of the kernel.

* It would probably make sense to "over comment" the source code so that 
it is a good teaching platform for basic device-mapper and bio programming.

This project is a spin-off of a much bigger proprietary device-mapper 
module.  Nothing in the dm-ramdisk module driver is really all that 
special except that it is a functional ramdisk in less than 300 lines of 
code.

If you think there is any interest in this simple module, I would be 
happy to send you a copy (or anyone else for that matter).

Thank you,
Doug Dumitru
CTO EasyCo LLC

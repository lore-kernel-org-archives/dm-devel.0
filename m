From: Taavi Ilves <ilvez@ut.ee>
Subject: Writing basic functions using libdevmapper.h
Date: Mon, 01 Aug 2005 17:47:34 +0300
Message-ID: <42EE3606.8030003@ut.ee>
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

Hi!

I'm a quite C newbie, but for my school-project I need something to be 
done with device-mapper.

Problem is quite simple: I have a device-mapper device ( in /dev/mapper 
) and I must find out which loop ( or actually whatever ) device is 
behind that mapper-device device.

Example: status output with cryptsetup

# cryptsetup status /dev/mapper/secret10
/dev/mapper//dev/mapper/secret10 is active:
   cipher:  aes-cbc-plain
   keysize: 256 bits
   device:  /dev/loop/1
   offset:  0 sectors
   size:    917 sectors
   mode:    read/write

This device field is what I'm looking for. I have looked into dm-setup 
and cryptsetup too, where libdevmapper.h is being used to get such 
information, but those applications were quite advance for me to study.

So I seek documentation and maybe some simple examples to learn how to 
use libdevmapper.h . I don't need full source-code solution for my 
problem, but still I welcome anything that leads to the solution. Thanks 
ahead!

Best wishes,
Taavi Ilves

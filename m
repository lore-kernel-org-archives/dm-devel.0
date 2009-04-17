From: Robert Hancock <hancockrwd@gmail.com>
Subject: Barriers on LVM?
Date: Thu, 16 Apr 2009 22:35:08 -0600
Message-ID: <49E806FC.80000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752355AbZDQEfl@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

I thought somebody mentioned that LVM now had barrier support for 
single-disk configurations in 2.6.29, but my dmesg seems to say 
otherwise. This is essentially a default Fedora disk layout with root 
and swap partitions inside an LVM on a single SATA drive with 2.6.29.1:

EXT4-fs: barriers enabled

...

JBD: barrier-based sync failed on dm-0:8 - disabling barriers

Is proper LVM barrier support coming any time soon? It seems a bit 
brutal that the default disk layout on many systems (and almost all 
Fedora ones, which will default to ext4 in Fedora 11) can't support 
whatever data integrity needs ext4 is using them for..

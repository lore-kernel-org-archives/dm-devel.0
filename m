From: Tomasz Chmielewski <mangoo-Nem3ZqsbT/g@public.gmane.org>
Subject: SMP-aware kcryptd?
Date: Mon, 13 Apr 2009 15:41:33 +0200
Message-ID: <49E3410D.9040500@wpkg.org>
Reply-To: dm-crypt-4q3lyFh4P1g@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-crypt-return-3153-glkdd-dm-crypt=m.gmane.org-4q3lyFh4P1g@public.gmane.org>
List-Post: <mailto:dm-crypt-4q3lyFh4P1g@public.gmane.org>
List-Help: <mailto:dm-crypt-help-4q3lyFh4P1g@public.gmane.org>
List-Unsubscribe: <mailto:dm-crypt-unsubscribe-4q3lyFh4P1g@public.gmane.org>
List-Subscribe: <mailto:dm-crypt-subscribe-4q3lyFh4P1g@public.gmane.org>
To: dm-crypt-4q3lyFh4P1g@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

Currently, the trend with CPUs is to add more cores rather than increase 
the speed of a single core.

This does not scale very well with certain things in the Linux kernel. 
One of them is kcryptd.


A system able to deliver data with a speed of ~200 MB/s from a RAID 
array, will be only able to deliver a fraction of it (i.e. ~40 MB/s in 
my case) when reads are being done from a dm-crypt device.

This is because kcryptd is not SMP-aware: it performs all calculations 
on a single logical CPU only.

Are there any plans to change it?


-- 
Tomasz Chmielewski
http://wpkg.org

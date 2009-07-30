From: Avi Kivity <avi@redhat.com>
Subject: Re: 2.6.31-rc4 oops in fsnotify extending logical volume
Date: Thu, 30 Jul 2009 12:40:16 +0300
Message-ID: <4A716A80.5020907@redhat.com>
References: <4A7068C9.40802@redhat.com> <200907292313.47762.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752015AbZG3Jfv@vger.kernel.org>
In-Reply-To: <200907292313.47762.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: dm-devel@redhat.com, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On 07/30/2009 12:13 AM, Rafael J. Wysocki wrote:
> On Wednesday 29 July 2009, Avi Kivity wrote:
>    
>> # lvextend -L +50G /dev/vg0/images
>>      
>
> I guess this is a regression?
>
>    

It's never happened to me before, and I extend volumes regularly, so I'd 
say it's a regression.  On the other hand after a reboot the command 
worked with the same kernel.

-- 
error compiling committee.c: too many arguments to function

From: Bernd Zeimetz <bernd@bzed.de>
Subject: Re: Multipathing with RHEL4 U2 on EMC DMX
Date: Thu, 16 Feb 2006 22:37:23 +0100
Message-ID: <43F4F093.4000905@bzed.de>
References: <2CF4E90F20CF3C4DBD3A71BD9FA2758D122F66@PSCDALPEXCH03.perotsystems.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2CF4E90F20CF3C4DBD3A71BD9FA2758D122F66@PSCDALPEXCH03.perotsystems.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

>         SCSI error : <0 0 0 6> return code = 0x20000
>         end_request: I/O error, dev sdd, sector 64078960
>         end_request: I/O error, dev sdd, sector 64078961
>         device-mapper: dm-multipath: Failing path 8:48.
>         SCSI error : <1 0 0 6> return code = 0x20000
>         end_request: I/O error, dev sdl, sector 34888112
>         end_request: I/O error, dev sdl, sector 34888113
>         device-mapper: dm-multipath: Failing path 8:176.
>
we had this problem with our buggy CX here, too. I thought that the CX
had some issues, but now I start to think that's a fault on the kernel side.

If anybody is interested - as the buggy CX will be replaced, we're
moving our production data to a different storage until we have the new
machine. The old one will be used as additional disk-to-disk backup, but
I can't see there any problems in testing/debugging stuff with it. At
least I can put it under heavy load and see what will happen.

Any ideas on that?



Best regards,

Bernd Zeimetz
Darmstadt University of Technology

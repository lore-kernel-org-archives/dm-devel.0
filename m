From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] multipathd: Suppress uninteresting data race
	reports
Date: Mon, 29 Aug 2016 08:51:33 -0700
Message-ID: <72cf1f62-3727-1ca0-4400-b6e352a98a08@sandisk.com>
References: <01747bb5-c10e-a3b6-e440-d9443837a6f7@sandisk.com>
	<CABr-Gnc6OQRhUeXtkHn-_CVYcSvYco78i1euggauTcjVNSrv5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-Gnc6OQRhUeXtkHn-_CVYcSvYco78i1euggauTcjVNSrv5A@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 08/29/2016 12:19 AM, Christophe Varoqui wrote:
> I think it would be fair to detect the valgrind headers presence in the
> Makefile and ifdef the include (else define dummy ANNOTATE_* macros).
>
> Would you care to prepare that ?

Hello Christophe,

How about adding a copy of the valgrind.h and helgrind.h header files to 
the multipath-tools source tree? This is the approach that is followed 
by several other projects, e.g. chromium. See also 
https://chromium.googlesource.com/chromium/src/base/+/master/third_party/valgrind/valgrind.h.

Thanks,

Bart.

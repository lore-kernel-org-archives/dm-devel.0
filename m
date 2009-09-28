From: Mike Galbraith <efault@gmx.de>
Subject: Re: IO scheduler based IO controller V10
Date: Mon, 28 Sep 2009 07:55:15 +0200
Message-ID: <1254117315.6809.9.camel@marge.simson.net>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
	 <4ABC28DE.7050809@datenparkplatz.de> <20090925202636.GC15007@redhat.com>
	 <1253976676.7005.40.camel@marge.simson.net>
	 <1254034500.7933.6.camel@marge.simson.net>
	 <20090927164235.GA23126@kernel.dk>
	 <1254075359.7354.66.camel@marge.simson.net>
	 <1254110648.7683.3.camel@marge.simson.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751812AbZI1FzV@vger.kernel.org>
In-Reply-To: <1254110648.7683.3.camel@marge.simson.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
List-Id: dm-devel.ids

P.S.

On Mon, 2009-09-28 at 06:04 +0200, Mike Galbraith wrote:

> - = virgin tip v2.6.31-10215-ga3c9602
> + = with patchlet
>                                                             Avg
> dd pre         67.4     70.9     65.4     68.9     66.2     67.7-
>                65.9     68.5     69.8     65.2     65.8     67.0-     Avg
>                70.4     70.3     65.1     66.4     70.1     68.4-     67.7-
>                73.1     64.6     65.3     65.3     64.9     66.6+     65.6+     .968
>                63.8     67.9     65.2     65.1     64.4     65.2+
>                64.9     66.3     64.1     65.2     64.8     65.0+
> perf stat      8.66    16.29     9.65    14.88     9.45     11.7-
>               15.36     9.71    15.47    10.44    12.93     12.7-
>               10.55    15.11    10.22    15.35    10.32     12.3-     12.2-
>                9.87     7.53    10.62     7.51     9.95      9.0+      9.1+     .745
>                7.73    10.12     8.19    11.87     8.07      9.1+
>               11.04     7.62    10.14     8.13    10.23      9.4+
> dd post        63.4     60.5     66.7     64.5     67.3     64.4-
>                64.4     66.8     64.3     61.5     62.0     63.8-
>                63.8     64.9     66.2     65.6     66.9     65.4-     64.5-
>                60.9     63.4     60.2     63.4     65.5     62.6+     61.8+     .958
>                63.3     59.9     61.9     62.7     61.2     61.8+
>                60.1     63.7     59.5     61.5     60.6     61.0+

Deadline and noop fsc^W are less than wonderful choices for this load.

perf stat     12.82     7.19     8.49     5.76      9.32   anticipatory
              16.24   175.82   154.38   228.97    147.16   noop
              43.23    57.39    96.13   148.25    180.09   deadline
              28.65   167.40   195.95   183.69    178.61   deadline v2.6.27.35

	-Mike

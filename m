From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] multipath-tools: replace 64bit archs macros
 by __LP64__
Date: Tue, 13 Jun 2017 15:38:59 +0000
Message-ID: <1497368335.2804.6.camel@wdc.com>
References: <20170519013818.15130-1-xose.vazquez@gmail.com>
	<1495164703.3174.1.camel@sandisk.com>
	<13c7d90c-47d6-fe96-d7e2-ce1aa0b266ca@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <13c7d90c-47d6-fe96-d7e2-ce1aa0b266ca@gmail.com>
Content-Language: en-US
Content-ID: <18C96195CC12B042843F10319DC4379F@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sun, 2017-06-11 at 21:14 +0200, Xose Vazquez Perez wrote:
> On 05/19/2017 05:31 AM, Bart Van Assche wrote:
> > Since there is only one user of int2ptr(), please remove the macro definitions
> > and use the following construct: (void *)(uintptr_t)(...).
> 
> No time for a proper patch, use it as an interim fix.

Hello Jose,

I will post a patch to remove int2ptr().

Bart.

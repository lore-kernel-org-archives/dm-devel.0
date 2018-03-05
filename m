From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 5/6] libmultipath: Fix sgio_get_vpd()
Date: Mon, 5 Mar 2018 21:13:51 +0000
Message-ID: <1520284430.2826.39.camel@wdc.com>
References: <20180301192935.14643-1-bart.vanassche@wdc.com>
	<20180301192935.14643-6-bart.vanassche@wdc.com>
	<1520268808.7660.23.camel@suse.com> <1520269758.7660.29.camel@suse.com>
	<1520277283.7660.46.camel@suse.com> <1520277522.2826.34.camel@wdc.com>
	<1520282850.7660.49.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1520282850.7660.49.camel@suse.com>
Content-Language: en-US
Content-ID: <B24EC9BC0E8E1A41AFFCA2D840B6E717@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "mwilck@suse.com" <mwilck@suse.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, 2018-03-05 at 21:47 +0100, Martin Wilck wrote:
> On Mon, 2018-03-05 at 19:18 +0000, Bart Van Assche wrote:
> > On Mon, 2018-03-05 at 20:14 +0100, Martin Wilck wrote:
> > > Unless you object, I'll repost your series rebased on mine.
> > 
> > Hello Martin,
> > 
> > Before you start working on that: has your patch series already been
> > posted
> > on the dm-devel mailing list?
> 
> Yes. "PATCH v2 00/20] Various multipath-tools fixes" ff.
> https://www.redhat.com/archives/dm-devel/2018-January/msg00219.html

Ah, thanks, but unfortunately these patches are no longer in my mailbox. I
pulled these from https://github.com/openSUSE/multipath-tools. I'm fine with
my patches being rebased on top of your series, whether or not the following
issues get addressed:
* Several patches that are on the upstream-queue branch introduce trailing
  whitespace.
* The macro FREE_CONST() should never have been introduced. Introducing such
  a macro namely introduces the risk of calling free() for a string constant,
  something that should never happen. Have you considered to declare
  dynamically allocated strings, e.g. the result of strdup(), as char *
  instead of const char * ? I think with that change the FREE_CONST() macro
  definitions can be removed again.

Thanks,

Bart.

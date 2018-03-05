From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 3/6] libmultipath,
 alloc_path_with_pathinfo(): Declare third argument const
Date: Mon, 5 Mar 2018 16:21:11 +0000
Message-ID: <1520266870.2826.14.camel@wdc.com>
References: <20180301192935.14643-1-bart.vanassche@wdc.com>
	<20180301192935.14643-4-bart.vanassche@wdc.com>
	<1520266739.7660.10.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1520266739.7660.10.camel@suse.com>
Content-Language: en-US
Content-ID: <AE82C3DD6E613D43B9ABCF8D57673FAE@namprd04.prod.outlook.com>
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

On Mon, 2018-03-05 at 17:18 +0100, Martin Wilck wrote:
> On Thu, 2018-03-01 at 11:29 -0800, Bart Van Assche wrote:
> > Since the third argument of this function is not modified inside that
> > function, declare it const.
> > 
> > Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> 
> ACK, but this hunk is part of my previously posted patch "libmultipath:
> const qualifier for wwid and alias", which includes some more changes
> along similar lines and is part of a larger patch set that tries to
> improve "const" usage in libmultipath.

Hello Martin,

If this patch duplicates some of your work then I'm fine with dropping this
patch.

Bart.

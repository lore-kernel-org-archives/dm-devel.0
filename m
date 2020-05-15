From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm:for-next 53/58]
 drivers/md/dm-zoned-metadata.c:779:3: error: implicit declaration of
 function 'export_uuid'
Date: Fri, 15 May 2020 10:32:55 -0400
Message-ID: <20200515143254.GA5098@redhat.com>
References: <202005151432.U61i8wOc%lkp@intel.com>
	<a1e65e5a-4b23-6c6e-d52f-7bf6eb69e7c8@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a1e65e5a-4b23-6c6e-d52f-7bf6eb69e7c8@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Hannes Reinecke <hare@suse.de>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, dm-devel@redhat.com, kbuild-all@lists.01.org, kbuild test robot <lkp@intel.com>, Bob Liu <bob.liu@oracle.com>
List-Id: dm-devel.ids

On Fri, May 15 2020 at  3:25am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> Hi Mike,
> 
> This is cause by missing commit d01cd62400b3 ("uuid: Add inline
> helpers to import / export UUIDs"), which went into 5.7.
> Mind to update your tree?

Rebased on v5.7-rc5, thanks

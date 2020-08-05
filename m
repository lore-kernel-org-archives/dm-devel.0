From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 00/74] multipath-tools series part V: removed
 path handling
Date: Wed, 05 Aug 2020 22:34:31 +0200
Message-ID: <31370014486ad4907cb1e443ce9ab8b24b1c0c41.camel@suse.com>
References: <311e3cc177cb481e872fd8b0909bddfd@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <311e3cc177cb481e872fd8b0909bddfd@h3c.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Chongyun Wu <wu.chongyun@h3c.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Guozhonghua <guozhonghua@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Chengchiwen <chengchiwen@h3c.com>, Wangyong <wang.yongD@h3c.com>, Zhangguanghui <zhang.guanghui@h3c.com>
List-Id: dm-devel.ids

On Mon, 2020-07-20 at 01:52 +0000, Chongyun Wu wrote:
> Hi Marin and all,
> 
> With below patches, run up/down script for a week, DM IO blocked
> issue not happened again, I think those patches works.
> 
> Tested-by: wuchongyun (Cloud) <wu.chongyun@h3c.com>

Thanks a lot! So the hope I expressed in the cover letter came true :-)
That's good to know, and should be a data point in our discussion about
the right treatment of pathvec.

Martin

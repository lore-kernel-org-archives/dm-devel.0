From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 01/14] multipathd: return if
 dm_get_major_minor failed in, cli_add_map
Date: Fri, 04 Sep 2020 15:13:55 +0200
Message-ID: <f0c1bcd45d81b3a00562b696121e4c08a37d6361.camel@suse.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
	<b1baac25-58c2-8f27-67bd-5d050fcdf8c7@huawei.com>
	<e525938e5b810958512eb623898fd732bd8482c4.camel@suse.com>
	<ef74857c-c81d-c0ec-4692-a9cd8299a99c@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ef74857c-c81d-c0ec-4692-a9cd8299a99c@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Fri, 2020-09-04 at 10:48 +0800, lixiaokeng wrote:
> 
> On 2020/9/4 1:26, Martin Wilck wrote:
> > Why not just quit the "do" loop in the error case
> > for dm_get_major_minor()?
> > 
> > Martin
> 
> If dm_get_major failed at first time, it will be executed again
> for some reason I don't know in the original code. Quiting the
> "do" loop in the error case for dm_get_major_minor() is against
> the twice attempt rule.

Right. 

Then, to solve the problem you're concerned about, it should be
sufficient to initialize both major and minor to -1, or simply refrain
from printing them in the log message in the first place.

At a closer look, the logic of the function is flawed; at least
if get_refwwid() doesn't return a usable refwwid, there's no point in
trying again.

Thanks,
Martin


> 
> Lixiaokeng
> > >  		else {
> > >  			sprintf(dev_path, "dm-%d", minor);
> > >  			alias = dm_mapname(major, minor);
> > > +			if (!alias)
> > > +				condlog(2, "%s: mapname not found for
> > > %d:%d",
> > > +					param, major, minor);
> > >  		}
> > >  		/*if there is no mapname found, we first create the
> > > device*/
> > >  		if (!alias && !count) {
> > > -			condlog(2, "%s: mapname not found for %d:%d",
> > > -				param, major, minor);
> > >  			get_refwwid(CMD_NONE, param, DEV_DEVMAP,
> > >  				    vecs->pathvec, &refwwid);
> > >  			if (refwwid) {
> > 
> > 
> > .
> > 

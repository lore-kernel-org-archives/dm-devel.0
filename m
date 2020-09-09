From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 09/14] libmultipath: check whether
 mp->features is NULl in, assemble_map
Date: Wed, 09 Sep 2020 12:11:12 +0200
Message-ID: <3ae3e9fdc5692b5d5244e58e777a18c14bda5abd.camel@suse.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
	<40cf77df-eaa3-fb72-69fd-9f865d12dc34@huawei.com>
	<20200904213048.GE11108@octiron.msp.redhat.com>
	<8dd72a70-991a-cb7d-3279-3d5036df1b9d@huawei.com>
	<20200908154540.GK11108@octiron.msp.redhat.com>
	<c50b9997b3c4a55d6a2858cd6b931bea93b14bfe.camel@suse.com>
	<3154dc82-e5cf-5d34-6955-04a0ad6e01f0@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3154dc82-e5cf-5d34-6955-04a0ad6e01f0@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel, list <dm-devel@redhat.com>, linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Wed, 2020-09-09 at 11:18 +0800, lixiaokeng wrote:
> 
> On 2020/9/9 0:35, Martin Wilck wrote:
> > 
> > What about this:
> > 
> > assemble_map() is only called from setup_map(), which sets mp-
> > >features 
> > in select_features(). So what we should do is check for NULL after
> > select_features(), or have that function return an error code if
> > strdup
> > fails, and bail out early in setup_map() in that case.
> > 
> > Then we simply need to add a comment in assemble_map() saying that 
> > mp->features must be non-null when this function is called.
> > 
> > As I said earlier, I'm of course not against checking function
> > parameters, but here we should fail to setup a "struct multipath"
> > in
> > the first place in setup map(), rather than returning an
> > incompletely
> > initialized one. If we handle it this way, we don't need to check
> > the
> > fields of struct multipath over and over again. Similar arguments
> > hold
> > for other structs.
> > 
> > Of course this kind of assumption needs to be better documented in
> > the
> > code.
> > 
> > Regards
> > Martin
> > 
> > 
> Hi Martin,
>    If I don't misunderstand, we check feature after select_features
> and
> return 1 if feature is NULL in setup_map. We delete strdup and add
> message "mp->features must be non-null" in assemble_map. Like this:
> ---
> select_features(conf, mpp);
> if (!mpp->featrues)
> 	return 1;
> 
> ---
> /* mp->feature must not be NULL */
> APPEND(p, end, "%s %s %i %i", mp->features, mp->hwhandler
> ---

Yes. I guess error handling in setup_map() needs a closer look, too.

Martin

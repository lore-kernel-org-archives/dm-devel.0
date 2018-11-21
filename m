From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH] multipathd: fix mpp->hwe handling when paths
	are freed
Date: Wed, 21 Nov 2018 10:16:33 +0100
Message-ID: <ade3939bb03d5f8398357ad3981b9a393a43813c.camel@suse.de>
References: <1542774284-20935-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1542774284-20935-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
List-Id: dm-devel.ids

On Tue, 2018-11-20 at 22:24 -0600, Benjamin Marzinski wrote:
> Commit 1f962693 didn't deal with all of cases where a path that was
> part
> of a multipath device could be removed. verify_paths() removes any
> path
> that no longer exists in sysfs.  mpp->hwe needs to be updated here as
> well, since verify_paths() could remove the path whose hwe vector is
> pointed to by mpp->hwe.  Also, now that extract_hwe_from_path() is
> called in verify_paths(), the extract_hwe_from_path() calls that
> happened immediately after verify_paths() can be dropped.
> 
> The other part of this fix is mostly cosmetic. In ev_add_path(), if
> domap() fails after the path is added to the multipath device and
> verify_paths() is called, the code can loop back to the rescan label.
> If
> the size of the path or the multipath device changed in the interim,
> ev_add_path() would remove the path, without updating mpp->hwe; but
> there is no way for the size to change. Just to make that clearer in
> the
> code, I've moved the size check to before the rescan label so it only
> happens once.
> 
> Fixes: 1f962693 "multipathd: fix mpp->hwe handling on path removal"
> Cc: Martin Wilck <mwilck@suse.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Thanks!
Reviewed-by: Martin Wilck <mwilck@suse.com>

Martin

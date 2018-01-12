From: Martin Wilck <mwilck@suse.com>
Subject: Re: multipath-tools 0.7.4 failure to remove device
Date: Fri, 12 Jan 2018 21:35:39 +0100
Message-ID: <1515789339.3409.33.camel@suse.com>
References: <20180112083833.apsybil4ux4d2y32@jak-x230>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-JFTr1cJieytY1f6t0bgm"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180112083833.apsybil4ux4d2y32@jak-x230>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Julian Andres Klode <julian.klode@canonical.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Device-mapper development mailing list <dm-devel@redhat.com>
Cc: Guan Junxiong <guanjunxiong@huawei.com>
List-Id: dm-devel.ids


--=-JFTr1cJieytY1f6t0bgm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

On Fri, 2018-01-12 at 09:38 +0100, Julian Andres Klode wrote:
> 
> and then we get I/O error on the device and it's rendered unusable.
> It's
> also crashing in uev_pathfail_check() occassionally because
> find_path_by_devt()
> returns NULL, so I applied the following patch to at least continue,
> but that's
> obviously wrong - We get an udev event for a device which does not
> exist in /dev
> (but it should)?

Adding Guan, as the pathfail check is from his code.

> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1090,6 +1090,11 @@ uev_pathfail_check(struct uevent *uev, s
>  	lock(&vecs->lock);
>  	pthread_testcancel();
>  	pp = find_path_by_devt(vecs->pathvec, devt);
> +	if (!pp) {
> +		condlog(3, "%s: Cannot find path by dm path %s",
> uev->kernel, devt);
> +		FREE(devt);
> +		goto out;
> +	}
>  	r = io_err_stat_handle_pathfail(pp);
>  	lock_cleanup_pop(vecs->lock);

You need to cleanup the lock in the error path. I'd pefer checking
for a NULL path argument in io_err_stat_handle_pathfail(). See
attachment.

I'm assuming that you are not using the "marginal path" logic. In
general I don't like the fact that PATH_FAILED events are handled at
all in multipathd if this logic is inactive; that code path is only
needed for this purpose. But that's just a side note.

> Jan 12 09:17:52 autopkgtest kernel: device-mapper: multipath: Failing
> path 8:16.
> > Jan 12 09:17:52 autopkgtest kernel: sd 3:0:0:1: [sdb] Synchronizing
> SCSI cache
> > Jan 12 09:17:52 autopkgtest multipath[6909]: 8:16: cannot find
> block device
> Jan 12 09:17:52 autopkgtest multipath[6909]: 8:16: Empty device
name
> Jan 12 09:17:52 autopkgtest multipath[6909]: 8:16: Empty device
name
> > Jan 12 09:17:52 autopkgtest multipath[6909]: get_udev_device: >
> failed to look up 8:16 with type 1
> > Jan 12 09:17:52 autopkgtest multipath[6909]: dm-0: usable paths
> found
> > Jan 12 09:17:53 autopkgtest iscsid[649]: Connection2:0 to [target:
> iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] through
> [iface: default] is shutdown.

> > We can see that it correctly removed the first device (sda) -
> except well, it seems to try
> >again and fail with the part where it would have crashed. But when
> it tries to lookup the
> second one it fails.

> > Given that this works in 0.6.4, I think it's a bug that appeared
> later on,
> > but I can't really pin point the source of it.

Well, it may be because of the locking being broken by your patch.
If you look at the journal you sent, multipathd never prints a single
message after the removal of sda, until it says

Jan 12 09:18:37 autopkgtest multipathd[1980]: exit (signal)

That makes me think it hangs somehow, which could well be explained by
the lock not being released. Please retry with the attached patch.

We are seeing the *multipath* messages ([6069]) which are printed from
multipath during udev rule processing, because the map still holds
references to the deleted path. 

Regards,
Martin

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)

--=-JFTr1cJieytY1f6t0bgm
Content-Disposition: attachment;
	filename="deal-with-NULL-path-in-pathfail-handler.patch"
Content-Type: text/x-patch;
	name="deal-with-NULL-path-in-pathfail-handler.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

Y29tbWl0IGM0ZDQ4YzYzM2IwODI1OTQxMDI0YTM0YWNmMjMwNGE2ZjVhMmQxN2QgKEhFQUQgLT4g
dXBzdHJlYW0pCkF1dGhvcjogTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+CkRhdGU6ICAg
RnJpIEphbiAxMiAyMToyMTo0OSAyMDE4ICswMTAwCgogICAgbGlibXVsdGlwYXRoOiBkZWFsIHdp
dGggTlVMTCBwYXRoIGluIHBhdGhmYWlsIGhhbmRsZXIKICAgIAogICAgVGhpcyBhdm9pZHMgYSBj
cmFzaCBmb3IgcGF0aHMgd2hpY2ggYXJlIGFscmVhZHkgZGVsZXRlZC4KICAgIAogICAgUmVwb3J0
ZWQtYnk6IEp1bGlhbiBBbmRyZXMgS2xvZGUgPGp1bGlhbi5rbG9kZUBjYW5vbmljYWwuY29tPgoK
ZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9pb19lcnJfc3RhdC5jIGIvbGlibXVsdGlwYXRoL2lv
X2Vycl9zdGF0LmMKaW5kZXggNzVhNmRmNjdjMjA3Li5kMmQyMjc2YTUyM2UgMTAwNjQ0Ci0tLSBh
L2xpYm11bHRpcGF0aC9pb19lcnJfc3RhdC5jCisrKyBiL2xpYm11bHRpcGF0aC9pb19lcnJfc3Rh
dC5jCkBAIC0zMTUsNiArMzE1LDEwIEBAIGludCBpb19lcnJfc3RhdF9oYW5kbGVfcGF0aGZhaWwo
c3RydWN0IHBhdGggKnBhdGgpCiAJc3RydWN0IHRpbWVzcGVjIGN1cnJfdGltZTsKIAlpbnQgcmVz
OwogCisJaWYgKHBhdGggPT0gTlVMTCkgeworCQlpb19lcnJfc3RhdF9sb2coMSwgIiVzOiBjYWxs
ZWQgd2l0aCBlbXB0eSBwYXRoIiwgX19mdW5jX18pOworCQlyZXR1cm4gMTsKKwl9CiAJaWYgKHBh
dGgtPmlvX2Vycl9kaXNhYmxlX3JlaW5zdGF0ZSkgewogCQlpb19lcnJfc3RhdF9sb2coMywgIiVz
OiByZWluc3RhdGUgaXMgYWxyZWFkeSBkaXNhYmxlZCIsCiAJCQkJcGF0aC0+ZGV2KTsK


--=-JFTr1cJieytY1f6t0bgm
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-JFTr1cJieytY1f6t0bgm--

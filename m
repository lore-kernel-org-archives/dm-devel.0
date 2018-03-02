From: Martin Wilck <mwilck@suse.com>
Subject: Re: [RFC PATCH 05/20] libmultipath: don't update path
 groups when printing
Date: Fri, 02 Mar 2018 14:59:40 +0100
Message-ID: <1519999180.4169.60.camel@suse.com>
References: <20180220132658.22295-1-mwilck@suse.com>
	<20180220132658.22295-6-mwilck@suse.com>
	<20180228234016.GI14513@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-qOVqayUCr6ICZQsHhPam"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180228234016.GI14513@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


--=-qOVqayUCr6ICZQsHhPam
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

On Wed, 2018-02-28 at 17:40 -0600, Benjamin Marzinski wrote:
> On Tue, Feb 20, 2018 at 02:26:43PM +0100, Martin Wilck wrote:
> > Updating the prio values for printing makes no sense. The user
> > wants to see
> > the prio values multipath is actually using for path group
> > selection, and
> > updating the values here means actually lying to the user if the
> > prio values
> > have changed, but multipathd hasn't updated them internally.
> > 
> > If we really don't update the pathgroup prios when we need to, this
> > should be
> > fixed elsewhere. The current wrong output would just hide that if
> > it occured.
> > 
> > Moreover, correctness forbids changing properties so deeply in a
> > code path
> > that's supposed to print them only. Finally, this piece of code
> > prevents the
> > print.c code to be converted to proper "const" usage.
> 
> Well, it is true that we've only been updating the path group
> priority
> when we've needed it, and we've only need it to be uptodate when we
> are
> picking a new pathgroup, or are printing it out. When failback is set
> to
> "manual", we rarely are picking a new pathgroup, so we rarely update
> the
> pathgroup prio. 
> 
> [...]
>
> I'd be fine with simply updating the path group priority whever we
> change a
> path's priority, if we aren't updating it when printing it. The
> bigger
> work of actually making sure that the path group order it the table
> is always uptodate needs to happen, but it doesn't need to happen in
> this patchset.

I just reviewed the code flow in check_path(), and here's what I see:

1. calls update_prio(pp, new_path_up)
   -> updates path's prio, or all paths' prios if the path was
      reinstated

Now it calls either

2a. update_path_groups() (for group_by_prio and failback immediate)
  (-> reload_map() -> setup_map() -> select_path_group()
  -> path_group_prio_update()), or
  
2b. need_switch_pathgroup() (otherwise)
  
So all we need to make sure is that need_switch_pathgroup() calls 
select_path_group(). It does that already, except for the "failback
manual" case.

So all we need is IMO the attached patch. Tell me what you think.

[All of the above is only called if (!mpp->wait_for_udev), but if
wait_for_udev is set, either when the event arrives or the wait times
out, we'll call reconfigure() which makes sure all priorities are
correct].

Best,
Martin

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)

--=-qOVqayUCr6ICZQsHhPam
Content-Disposition: attachment;
	filename="0001-multipathd-update-path-group-prio-in-check_path.patch"
Content-Type: text/x-patch;
	name="0001-multipathd-update-path-group-prio-in-check_path.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSAxNDlmNDQ1OGQxMzhkNTA0ZWU1OTQ3YWFhNmUzOGQxMzRiMjEzNjhhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4KRGF0ZTog
RnJpLCAyIE1hciAyMDE4IDE0OjUxOjUyICswMTAwClN1YmplY3Q6IFtQQVRDSF0gbXVsdGlwYXRo
ZDogdXBkYXRlIHBhdGggZ3JvdXAgcHJpbyBpbiBjaGVja19wYXRoCgpUaGUgcHJldmlvdXMgcGF0
Y2ggImxpYm11bHRpcGF0aDogZG9uJ3QgdXBkYXRlIHBhdGggZ3JvdXBzIHdoZW4gcHJpbnRpbmci
CnJlbW92ZWQgdGhlIGNhbGwgdG8gcGF0aF9ncm91cF9wcmlvX3VwZGF0ZSgpIGluIHRoZSBwcmlu
dGluZyBjb2RlIHBhdGguClRvIGNvbXBlbnNhdGUgZm9yIHRoYXQsIHJlY2FsY3VsYXRlIHBhdGgg
Z3JvdXAgcHJpbyBhbHNvIHdoZW4gaXQncyBub3QKc3RyaWN0bHkgbmVjZXNzYXJ5IChpLmUuIGlm
IGZhaWxiYWNrICJtYW51YWwiIGlzIHNldCkuCgpTaWduZWQtb2ZmLWJ5OiBNYXJ0aW4gV2lsY2sg
PG13aWxja0BzdXNlLmNvbT4KLS0tCiBtdWx0aXBhdGhkL21haW4uYyB8IDggKysrKysrLS0KIDEg
ZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvbXVsdGlwYXRoZC9tYWluLmMgYi9tdWx0aXBhdGhkL21haW4uYwppbmRleCBlMWQ5ODg2MWE4
NDEuLjYxNzM5YWM2ZWE1OSAxMDA2NDQKLS0tIGEvbXVsdGlwYXRoZC9tYWluLmMKKysrIGIvbXVs
dGlwYXRoZC9tYWluLmMKQEAgLTI1Miw4ICsyNTIsOSBAQCBuZWVkX3N3aXRjaF9wYXRoZ3JvdXAg
KHN0cnVjdCBtdWx0aXBhdGggKiBtcHAsIGludCByZWZyZXNoKQogCXN0cnVjdCBwYXRoICogcHA7
CiAJdW5zaWduZWQgaW50IGksIGo7CiAJc3RydWN0IGNvbmZpZyAqY29uZjsKKwlpbnQgYmVzdHBn
OwogCi0JaWYgKCFtcHAgfHwgbXBwLT5wZ2ZhaWxiYWNrID09IC1GQUlMQkFDS19NQU5VQUwpCisJ
aWYgKCFtcHApCiAJCXJldHVybiAwOwogCiAJLyoKQEAgLTI3Miw4ICsyNzMsMTEgQEAgbmVlZF9z
d2l0Y2hfcGF0aGdyb3VwIChzdHJ1Y3QgbXVsdGlwYXRoICogbXBwLCBpbnQgcmVmcmVzaCkKIAlp
ZiAoIW1wcC0+cGcgfHwgVkVDVE9SX1NJWkUobXBwLT5wYXRocykgPT0gMCkKIAkJcmV0dXJuIDA7
CiAKLQltcHAtPmJlc3RwZyA9IHNlbGVjdF9wYXRoX2dyb3VwKG1wcCk7CisJYmVzdHBnID0gc2Vs
ZWN0X3BhdGhfZ3JvdXAobXBwKTsKKwlpZiAobXBwLT5wZ2ZhaWxiYWNrID09IC1GQUlMQkFDS19N
QU5VQUwpCisJCXJldHVybiAwOwogCisJbXBwLT5iZXN0cGcgPSBiZXN0cGc7CiAJaWYgKG1wcC0+
YmVzdHBnICE9IG1wcC0+bmV4dHBnKQogCQlyZXR1cm4gMTsKIAotLSAKMi4xNi4xCgo=


--=-qOVqayUCr6ICZQsHhPam
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-qOVqayUCr6ICZQsHhPam--

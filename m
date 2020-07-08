From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: remove dead bdi congestion leftovers
Date: Wed, 8 Jul 2020 17:14:29 -0600
Message-ID: <b5d6df17-68af-d535-79e4-f95e16dd5632@kernel.dk>
References: <20200701090622.3354860-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <20200701090622.3354860-1-hch-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: dm-devel.ids

T24gNy8xLzIwIDM6MDYgQU0sIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOgo+IEhpIEplbnMsCj4g
Cj4gd2UgaGF2ZSBhIGxvdCBvZiBiZGkgY29uZ2VzdGlvbiByZWxhdGVkIGNvZGUgdGhhdCBpcyBs
ZWZ0IGFyb3VuZCB3aXRob3V0Cj4gYW55IHVzZS4gIFRoaXMgc2VyaWVzIHJlbW92ZXMgaXQgaW4g
cHJlcGFyYXRpb24gb2Ygc29ydGluZyBvdXQgdGhlIGJkaQo+IGxpZmV0aW1lIHJ1bGVzIHByb3Bl
cmx5LgoKUGxlYXNlIHJ1biBzZXJpZXMgbGlrZSB0aGlzIHRocm91Z2ggYSBmdWxsIGNvbXBpbGF0
aW9uLCBmb3IgYm90aCB0aGlzIG9uZQphbmQgdGhlIHByZXZpb3VzIHNlcmllcyBJIGhhZCB0byBm
aXggdXAgaXNzdWVzIGxpa2UgdGhpczoKCmRyaXZlcnMvbWQvYmNhY2hlL3JlcXVlc3QuYzogSW4g
ZnVuY3Rpb24g4oCYYmNoX2NhY2hlZF9kZXZfcmVxdWVzdF9pbml04oCZOgpkcml2ZXJzL21kL2Jj
YWNoZS9yZXF1ZXN0LmM6MTIzMzoxODogd2FybmluZzogdW51c2VkIHZhcmlhYmxlIOKAmGfigJkg
Wy1XdW51c2VkLXZhcmlhYmxlXQogMTIzMyB8ICBzdHJ1Y3QgZ2VuZGlzayAqZyA9IGRjLT5kaXNr
LmRpc2s7CiAgICAgIHwgICAgICAgICAgICAgICAgICBeCmRyaXZlcnMvbWQvYmNhY2hlL3JlcXVl
c3QuYzogSW4gZnVuY3Rpb24g4oCYYmNoX2ZsYXNoX2Rldl9yZXF1ZXN0X2luaXTigJk6CmRyaXZl
cnMvbWQvYmNhY2hlL3JlcXVlc3QuYzoxMzIwOjE4OiB3YXJuaW5nOiB1bnVzZWQgdmFyaWFibGUg
4oCYZ+KAmSBbLVd1bnVzZWQtdmFyaWFibGVdCiAxMzIwIHwgIHN0cnVjdCBnZW5kaXNrICpnID0g
ZC0+ZGlzazsKICAgICAgfCAgICAgICAgICAgICAgICAgIF4KCkRpZCB0aGUgc2FtZSBoZXJlLCBh
cHBsaWVkIGl0LgoKLS0gCkplbnMgQXhib2UKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCmRyYmQtZGV2IG1haWxpbmcgbGlzdApkcmJkLWRldkBsaXN0cy5s
aW5iaXQuY29tCmh0dHBzOi8vbGlzdHMubGluYml0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RyYmQt
ZGV2Cg==

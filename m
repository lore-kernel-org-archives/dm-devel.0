From: Jon Nelson <jnelson@jamponi.net>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re:
 dm-crypt barrier support is effective)
Date: Thu, 9 Dec 2010 14:38:00 -0600
Message-ID: <AANLkTik=ivDrBEzg1wQAp5AFzNtRRq1=NpvnowggU=_0__43561.0102875673$1291927206$gmane$org@mail.gmail.com>
References: <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
	<20101204193828.GB13871@redhat.com>
	<AANLkTin3A_ySn_sZQPqZMn-NORnteQZwTVVSiW_=r3sO@mail.gmail.com>
	<20101207142145.GA27861@think>
	<AANLkTikJt-ZOmzj68Jw92rjGHzu0EP-uCVD+eNSO=vGd@mail.gmail.com>
	<20101207182243.GB21112@redhat.com> <20101207193514.GA2921@thunk.org>
	<AANLkTim8UTkfxXV0AkEfjNq3tcmnrXdh6BQ1ibY5iYPy@mail.gmail.com>
	<20101209180111.GF2921@thunk.org>
	<AANLkTimAUB5L5Ptm4Fv=sQUmL9_P5azPRCKQnmU89xs8@mail.gmail.com>
	<20101209201359.GG2921@thunk.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20101209201359.GG2921@thunk.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ted Ts'o <tytso@mit.edu>, Jon Nelson <jnelson@jamponi.net>, Mike Snitzer <snitzer@redhat.com>, Chris Mason <chris.mason@oracle.com>, Matt <jackdachef@gmail.com>
List-Id: dm-devel.ids

T24gVGh1LCBEZWMgOSwgMjAxMCBhdCAyOjEzIFBNLCBUZWQgVHMnbyA8dHl0c29AbWl0LmVkdT4g
d3JvdGU6Cj4gT24gVGh1LCBEZWMgMDksIDIwMTAgYXQgMTI6MTA6NThQTSAtMDYwMCwgSm9uIE5l
bHNvbiB3cm90ZToKPj4KPj4gWW91IHNob3VsZCBiZSBPSywgdGhlcmUuIEFyZSB5b3UgdXNpbmcg
ZW5jcnlwdGlvbiBvciBubz8KPj4gSSBoYWQgZGlmZmljdWx0eSByZXBsaWNhdGluZyB0aGUgaXNz
dWUgd2l0aG91dCBlbmNyeXB0aW9uLgo+Cj4gWWVzLCBJJ20gdXNpbmcgZW5jcnlwdGlvbi4gwqBM
VUtTIHdpdGggYWVzLXh0cy1wbGFpbi1zaGEyNTYsIGFuZCB0aGVuCj4gTFZNIG9uIHRvcCBvZiBM
VUtTLgoKSG1tLgpUaGUgY2lwaGVyIGlzIGxpc3RlZCBhczoKYWVzLWNiYy1lc3NpdjpzaGEyNTYK
Cj4+ID4gSWYgeW91IGNhbiBwb2ludCBvdXQgaG93IHRvIHF1ZXJ5IHBnc3FsX3RtcCAoSSdtIHVz
aW5nIGEgY29tcGxldGVseQo+PiA+IGRlZmF1bHQgcG9zdGdyZXMgaW5zdGFsbCksIHRoYXQgd291
bGQgYmUgaGVscGZ1bCwgYnV0IEkgZG9uJ3QgdGhpbmsgaXQKPj4gPiB3b3VsZCBiZSBnb2luZyBh
bnl3aGVyZSBlbHNlLgo+Pgo+PiBOb3JtYWxseSBpdCdzIC92YXIvbGliL3Bnc3FsL2RhdGEvcGdz
cWxfdG1wIChvcgo+PiAvdmFyL2xpYi9wb3N0Z3Jlcy9kYXRhL3Bnc3FsX3RtcCBpbiB5b3VyIGNh
c2UpLiBCeSBwbGFjaW5nCj4+IC92YXIvbGliL3twb3N0Z3Jlc3FsLHBnc3FsfS9kYXRhIG9uIHRo
ZSBMVUtTICsgZXh0NCB2b2x1bWUsIG9uIGJvdGgKPj4gb3BlblNVU0UgMTEuMyBhbmQgS3VidW50
dSwgSSB3YXMgYWJsZSB0byByZXBsaWNhdGUgdGhlIHByb2JsZW0gZWFzaWx5LAo+PiBpbiBWaXJ0
dWFsQm94LiBJIGNhbiBnaXZlIHFlbXUgYSB0cnkuIEluIGJvdGggY2FzZXMgSSB3YXMgdXNpbmcg
YQo+PiAyLjYuMzd4IGtlcm5lbC4KPgo+IEFoLCBJJ20gbm90IHVzaW5nIHZpcnR1YWxpemF0aW9u
LiDCoEknbSBydW5uaW5nIG9uIGEgWDQxMCBsYXB0b3AsIG9uCj4gcmF3IGhhcmR3YXJlLiDCoFBl
cmhhcHMgdmlydHVhbGl6YXRpb24gc2xvd3MgdGhpbmdzIGRvd24gZW5vdWdoIHRoYXQgaXQKPiB0
cmlnZ2Vycz8gwqBPciBtYXliZSB5b3UncmUgcnVubmluZyB3aXRoIGEgbW9yZSBjb25zdHJhaW5l
ZCBtZW1vcnkgdGhhbgo+IEk/IMKgSG93IG11Y2ggbWVtb3J5IGRvIHlvdSBoYXZlIGNvbmZpZ3Vy
ZWQgaW4geW91ciBWTT8KCjUxMk1CLgoKJ2ZyZWUnIHJlcG9ydHMgNzVNQiwgNDE5TUIgZnJlZS4K
Ckkgb3JpZ2luYWxseSBub3RpY2VkIHRoZSBwcm9ibGVtIG9uIHJlYWxseSByZWFsIGhhcmR3YXJl
ICh0aGlua3BhZApUNjFwKSwgaG93ZXZlci4KCi0tIApKb24KCi0tCmRtLWRldmVsIG1haWxpbmcg
bGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9s
aXN0aW5mby9kbS1kZXZlbA==

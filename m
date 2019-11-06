From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-writecache: change config parameters using
	messages
Date: Wed, 6 Nov 2019 10:08:31 -0500
Message-ID: <20191106150831.GA27888@redhat.com>
References: <fa95f1f0-67d6-d02e-6999-ba1f90d70fe2@petasan.org>
	<8388b99a-a531-981e-9e36-8aeb3dffd18e@petasan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8388b99a-a531-981e-9e36-8aeb3dffd18e@petasan.org>
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
To: Maged Mokhtar <mmokhtar@petasan.org>
Cc: dm-devel@redhat.com, mpatocka@redhat.com
List-Id: dm-devel.ids

On Tue, Nov 05 2019 at  4:19pm -0500,
Maged Mokhtar <mmokhtar@petasan.org> wrote:

> Gentle ping please.
>=20
> It could add flexibility in changing cache parameters after device creati=
on.

I'm inclined to _not_ take this type of change.

Why isn't changing the config parameters via table reload viable for
you?

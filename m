From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: md: Fix Kconfig indentation
Date: Wed, 20 Nov 2019 10:37:22 -0500
Message-ID: <20191120153722.GA24993@redhat.com>
References: <20191120134110.14859-1-krzk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191120134110.14859-1-krzk@kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Nov 20 2019 at  8:41am -0500,
Krzysztof Kozlowski <krzk@kernel.org> wrote:

> Adjust indentation from spaces to tab (+optional two spaces) as in
> coding style with command like:
> =09$ sed -e 's/^        /\t/' -i */Kconfig
>=20
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

Thanks, I've picked this up but changed the subject from "md:" to "dm:"
considering the bulk of the changes relate to DM config sections.

Mike

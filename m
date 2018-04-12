From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 1/2] libmultipath: hwhandler auto-detection
	for ALUA
Date: Thu, 12 Apr 2018 14:49:48 -0500
Message-ID: <20180412194948.GW3103@octiron.msp.redhat.com>
References: <20180327215053.3631-1-mwilck@suse.com>
	<20180327215053.3631-2-mwilck@suse.com>
	<20180403203132.GF3103@octiron.msp.redhat.com>
	<1522788809.3801.109.camel@suse.com>
	<20180403212958.GH3103@octiron.msp.redhat.com>
	<1522829076.3955.24.camel@suse.com>
	<1523547819.4346.17.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1523547819.4346.17.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

On Thu, Apr 12, 2018 at 05:43:39PM +0200, Martin Wilck wrote:
> Hi Ben,
> =

> I'm unsure what to do. Do you still reject my patch? Or have you been
> convinced by Hannes and my arguments? =

> Or are you requesting changes? If yes, what? =


I still feel that it's better to make the default config const for
devices that may or may not be ALUA, and let detect_alua figure it out,
rather than allowing multipathd to override a specifically requested
ALUA hardware handler. This is especially true if
get_target_port_group_support() and get_target_port_group succeed, but
get_asymmetric_access_state() fails in detect_alua().  But I don't think
that transient alua errors like this are very likely during multpath
creation, so I not going to reject the patch.

Reviewed-by: Benjmain Marzinski <bmarzins@redhat.com>

> =

> Regards,
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)

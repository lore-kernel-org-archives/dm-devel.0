From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [RFC PATCH 0/2] multipath: change default devnode
	blacklist
Date: Fri, 5 Jun 2020 19:20:26 +0000
Message-ID: <9db7560136de15dad358e2832f236ae131e145ef.camel@suse.com>
References: <1591317060-25484-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1591317060-25484-1-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <22578AD5240ED44795EBC3D6AB806D47@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "nkshirsa@redhat.com" <nkshirsa@redhat.com>
List-Id: dm-devel.ids

Hi Ben,

On Thu, 2020-06-04 at 19:30 -0500, Benjamin Marzinski wrote:
> I recently got a request to add the Oracle ASM filer driver devices
> to
> multipath's builtin devnode blacklist.  However, instead of having to
> do
> always this for each device type individually, I decided to make
> multipath blacklist all non scsi, nvme, and dasd devnodes by default.
> This is what the multipath udev rules already do. If people don't
> like
> this solution, the alternative is to add another line to the default
> devnode blacklist like "^(asm/|oracleafd/|ofsctl)".

Thanks, this looks ok. But I'd like to propose an alternative idea:
Extend the RE syntax in our config file to allow negated regular=20
expressions. Like this:

blacklist {
    devnode "!(^(sd[a-z]|dasd[a-z]|nvme[0-9]))"
}

The "!(${RE})" construct would mean "everything that does not match ${RE}".
This logic would only be applied to an entire regex.
If a user needs a RE matching with "!(" and ending with ")", she can escape=
=20
the exclamation mark "\!(like this)".

AFAICS this could be implemented quite easily (by adding a "bool negate" fi=
eld
in struct blentry and some simple parser logic), and could be applied to ot=
her=20
REs in the config file as well. We could print this with "multipath -t", an=
d=20
we wouldn't need to document an exception.

It's also pretty much backwards-compatible, I don't think many people use
regexes starting with "!(" for multipath these days.

Regards,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer

From: "Matthias Rudolph" <Matthias.Rudolph@hds.com>
Subject: Re: Hitachi prioritizer ?
Date: Wed, 26 Apr 2006 16:15:09 +0100
Message-ID: <C67364BD62907640A033D1F4094CA7B703C83E5C@UKSPKEVS101.corp.hds.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: christophe varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids


Hi Christopher,

sorry - the software development is not my daily business....

The file hwtable.c should be changed from:

...
r +=3D store_hwe(hw, "HITACHI", "DF400", MULTIBUS, DEFAULT_GETUID);
r +=3D store_hwe(hw, "HITACHI", "DF500", MULTIBUS, DEFAULT_GETUID);
r +=3D store_hwe(hw, "HITACHI", "DF600", MULTIBUS, DEFAULT_GETUID);
...

to:

...
r +=3D store_hwe(hw, "HITACHI", "DF", GROUP_BY_PRIO, DEFAULT_GETUID,
"/sbin/pp_hds_modular %d", "0", "0", "readsector0", FAILBACK_IMMEDIATE);
r +=3D store_hwe(hw, "HITACHI", "OPEN-", MULTIBUS, DEFAULT_GETUID);
...

First entry is for Hitachi Modular Storage Active/Passive. The Product
inquiry always begins with "DF".
Second entry is for Hitachi Enterprise Storage Active/Active. The
Product inquiry always begins with "OPEN-".

Regards, Matthias

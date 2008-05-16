From: "Craig Simpson" <csimpson@visto.com>
Subject: multipathd: error calling out mpath_prio_hds_modular
Date: Fri, 16 May 2008 12:57:56 -0700
Message-ID: <ABFD05FF09D13E4883B757E75603624D011E94FF@ex-sea1.vistocorp.com>
References: <1210966544.12901.51.camel@plop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1210966544.12901.51.camel@plop>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


My RedHat 5.1 ES server (actually it is that but rebranded as Oracles
latest Linux) is  logging this in /var/log/message all the time.=20

It is attached to a Hitachi SAN device.=20

All seems to be working OK, but these errors go on and on.=20

Don't get what they mean?

May 16 19:48:01 wpe01 multipathd: error calling out
mpath_prio_hds_modular 65:0
May 16 19:48:01 wpe01 multipathd: error calling out
mpath_prio_hds_modular 65:16
May 16 19:48:01 wpe01 multipathd: error calling out
mpath_prio_hds_modular 65:32
May 16 19:48:01 wpe01 multipathd: error calling out
mpath_prio_hds_modular 65:48
May 16 19:48:01 wpe01 multipathd: error calling out
mpath_prio_hds_modular 65:64
May 16 19:48:01 wpe01 multipathd: error calling out
mpath_prio_hds_modular 65:80
May 16 19:48:01 wpe01 multipathd: error calling out
mpath_prio_hds_modular 8:0
May 16 19:48:01 wpe01 multipathd: error calling out
mpath_prio_hds_modular 8:16
May 16 19:48:01 wpe01 multipathd: error calling out
mpath_prio_hds_modular 8:32
May 16 19:48:01 wpe01 multipathd: error calling out
mpath_prio_hds_modular 8:48


Craig

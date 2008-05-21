From: "Craig Simpson" <csimpson@visto.com>
Subject: Round Robin vs Active/Passive
Date: Wed, 21 May 2008 07:48:18 -0700
Message-ID: <ABFD05FF09D13E4883B757E75603624D011E95B6@ex-sea1.vistocorp.com>
References: <8a6b34b03e0524aa66c862534fee9b7a@www3.mail.volny.cz>
	<18484.2693.62883.535755@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <18484.2693.62883.535755@notabene.brown>
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



For multipathd and dm is round-robin the only mode for multipathing? The
array we have as a newer Hitachi AMS200 and Active/Passive says the
documentation.=20

Using round-robin seems to work fine with it. Have 4 paths and they are
all sharing 1/4 of the load.=20

Are there other options that can be set in /etc/multipath.conf? I only
know of round-robin.=20

Craig =20

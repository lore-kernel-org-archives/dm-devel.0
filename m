From: Jussi Hamalainen <Jussi.Hamalainen@uta.fi>
Subject: RE: multipath -l displays nothing (Solved)
Date: Tue, 21 Mar 2006 21:37:05 +0200 (EET)
Message-ID: <Pine.GSO.4.58.0603212135300.3998@kalmia>
References: <C2EEB4E538D3DC48BF57F391F422779321B13A@SRMANNING.eng.emc.com>
	<Pine.GSO.4.58.0603211954110.3998@kalmia>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.GSO.4.58.0603211954110.3998@kalmia>
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

On Tue, 21 Mar 2006, Jussi Hamalainen wrote:

> Tried that. It didn't help with my current situation.

After a lot of trial and error I decided to compile device mapper and
multipathing statically into the kernel. Things seem a lot better
after rebooting.

--=20
Jussi H=E4m=E4l=E4inen         +358 3 3551 8086   University of Tampere
System administrator     +358 50  5900641   Computer Centre
ccjuha@uta.fi            TietoPinni  4166   http://www.uta.fi/laitokset/t=
kk

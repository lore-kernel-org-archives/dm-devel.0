From: NeilBrown <neilb@suse.de>
Subject: Re: Why all raid devices do have zero 'time in queue'
 value?
Date: Sun, 11 Mar 2012 13:10:51 +1100
Message-ID: <20120311131051.4ea7597c@notabene.brown>
References: <4F5BD6BE.7020405@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4322771432990309190=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4F5BD6BE.7020405@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: george.shuklin@gmail.com
List-Id: dm-devel.ids

--===============4322771432990309190==
Content-Type: multipart/signed; micalg=PGP-SHA1;
	boundary="Sig_/sVDPmHXLVdgngN3R=/P5nS0";
	protocol="application/pgp-signature"

--Sig_/sVDPmHXLVdgngN3R=/P5nS0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 11 Mar 2012 02:33:34 +0400 George Shuklin <george.shuklin@gmail.com>
wrote:

> Good day.
>=20
> I've look to stat for all MD devices I have (raid0, raid1, raid10) - all=
=20
> of them reports 0 for time_in_queue field in /sys/block/mdX/stat file.
>=20
> Is any reason why all raid devices contains no information about time=20
> spent on requests processing?
>=20

Wrong mailing list for MD - you want linux-raid@vger.kernel.org

But I can still answer :

These raid levels don't queue requests at all.  They just pass them straight
to the relevant underlying devices.

(Now admittedly RAID5 does queue requests but doesn't set the time_in_queue
field, but that is a separate issue).

If you really care about time_in_queue, you need to look at the queues of t=
he
member devices.

NeilBrown

--Sig_/sVDPmHXLVdgngN3R=/P5nS0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT1wJsznsnt1WYoG5AQIcKw/7BX0TYSLxwFNMoH75dl/D9EbC7nAIZgeJ
f0lmN1gJUgFeWf/LoiP38Kc+Dxu/rUUZg1aX3nrQPVQeCaNpjn0FTIymFY1Myd5e
gX6UV60Ik/WT5ttWXb65km28Dx833gHXt8YDH7EX9chPYmN9g7pOD7mPN3C+Wgmc
hholjYkod7HtZlkrz4h0D0oPq3kqNSuijQPslv+E1iCzwmWUMI6xT7+itcQjXnbe
ctNJDTs+1zrdSZs4gDSB3xZu5mxrLZuZQFgua2dAhITQmP+cHjqhgzcdO/aej0So
vy3ce2QvBKxBY2UZjudDLbQV3Uv6elrlVCJVLA0b1WgBBob/T5LfN5uPVKWej/3s
GEkxgS6sUqMz5GxQO2lKanxm3OO3zbiGzlek7irjYDVqaG2CAdnC8m06cRHATdnh
ctjje3UDU/a9xOASNEQS9xQgbc9EQxvZbf4NQlVBme7zWa+J5ZtkoidsEx1sbnWn
1sD8wBe8SmI0Mu4SbfXMuQt2ZxLc4ZUE5yRoirYVozZVLCzyQQLnFv3xTpZdpaXz
TzDjstOLM5MG1f5o+x/93jMSIcT7/Q1YitZEVAyvIIp9YSsgsez2ZPVVvVsqc1XQ
9JJkVPhjwg+ti46SttSZcuIJs6JAzVJfkNBBeXnYyVNLsnJMaFZCSs5hC2NW4QMb
AE6WkOMa2+g=
=e1Yi
-----END PGP SIGNATURE-----

--Sig_/sVDPmHXLVdgngN3R=/P5nS0--


--===============4322771432990309190==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4322771432990309190==--

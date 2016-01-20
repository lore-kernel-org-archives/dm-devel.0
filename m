From: "John Stoffel" <john@stoffel.org>
Subject: Re: dm-cache + storage client experiment
Date: Wed, 20 Jan 2016 11:14:48 -0500
Message-ID: <22175.45688.957297.958159@quad.stoffel.home>
References: <CALU38fe9yDR7=P2eNez0fvgsrBmcY=Q=BvTnC5cPzu-o=MgbzA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CALU38fe9yDR7=P2eNez0fvgsrBmcY=Q=BvTnC5cPzu-o=MgbzA@mail.gmail.com>
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
List-Id: dm-devel.ids

>>>>> "mlody3k" =3D=3D mlody3k  <mlody3k@gmail.com> writes:

mlody3k> Hi dm developers!
mlody3k> I'm during the experiment with dm-cache and storage client and I w=
ould be very grateful if some of
mlody3k> You will help me with some of my questions :).=A0

mlody3k> Simply, I would like to implement the write-through caching in the=
 client where:
mlody3k> =A0- dm-cache is only responsible to check whether requested data =
is in the cache device (return
mlody3k> requested data if hit, ENODATA if miss - do not read from origin) =
- in case of miss, my client
mlody3k> will read data from the origin.
mlody3k> =A0- dm-cache will write only to the cache device - client will wr=
ite data to the origin.

So instead, why don't you just have two different mount points, one
being /cache, the other being /slow, and have your app look for data
in /cache first, then pull from /slow.  If you write data, then you
just write it yourself where you want.

dm-cache is more of a block level tool, and you're looking for more of
a file level tool from what I can see.

Probably what you really want is to be able to tune and tweak the
algorithm inside dm-cache to do what you want.  In that case, I don't
have a clue how this would happen unfortunately.

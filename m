From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: queue_if_no_paths timeout handling
Date: Tue, 26 Jul 2005 20:07:42 +0200
Message-ID: <20050726180742.GC16649@marowsky-bree.de>
References: <C2EEB4E538D3DC48BF57F391F422779321AB67@SRMANNING.eng.emc.com>
	<20050724201713.GK8005@marowsky-bree.de>
	<20050725124135.GA21362@averon.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050725124135.GA21362@averon.dyndns.org>
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

On 2005-07-25T14:41:35, Christophe Varoqui <christophe.varoqui@free.fr> w=
rote:

> Maybe I miss some important point already raised in the past, but ...
> How about adding more params to queue_if_no_path ? eg,
>=20
> - timer value
> - pending io queue length
>=20
> That way kernel is kept free from policies,

If the timer value is handled inside the kernel, that would help. The
response it triggers could be the same like the user-space-to-kernel
heartbeat I described.

The pending queue length is probably not a good measure, I think, but it
would be cheap to add.

> and the framework survives a daemon crash.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"

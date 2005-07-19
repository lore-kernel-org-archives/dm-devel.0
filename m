From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [multipathd] kill clone() ?
Date: Tue, 19 Jul 2005 16:24:49 +0200
Message-ID: <20050719142449.GC13246@marowsky-bree.de>
References: <20050719133606.GA19691@averon.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050719133606.GA19691@averon.dyndns.org>
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

On 2005-07-19T15:36:06, Christophe Varoqui <christophe.varoqui@free.fr> w=
rote:

> I verified the path reinstate codepath, and it does only 1 dmt allocati=
on ... no callbacks anymore.
> So I guess it is safe to kill, be would like to raise the point one las=
t time.

Sounds like a good plan.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"

From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: panic in dm_pg_init_complete+0x10
Date: Wed, 9 Mar 2005 19:37:09 +0000
Message-ID: <20050309193709.GL19392@agk.surrey.redhat.com>
References: <C2EEB4E538D3DC48BF57F391F422779321A804@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A804@SRMANNING.eng.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "goggin, edward" <egoggin@emc.com>
Cc: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Mar 08, 2005 at 04:23:59PM -0500, goggin, edward wrote:
> Furthermore, I strongly suspect the panic is related to having
> multiple pg_init requests outstanding for the same multipath.

It was not the intention to allow concurrent pg_init requests
of any sort - but they are indeed not locked out correctly.

> (1) It is possible that an outstanding pg_init request and a new one

I don't see a need to allow that.  Only one priority group is
in use at once.  Even switch_group has to wait without being able
to cancel already-submitted pg_init I/O.
Not mea

Alasdair
-- 
agk@redhat.com

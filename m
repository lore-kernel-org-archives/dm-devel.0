From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Huge memory allocation
Date: Tue, 1 Mar 2011 13:46:06 +0000
Message-ID: <20110301134606.GN3626@agk-dp.fab.redhat.com>
References: <E04C10E329E0CD40816C9C17AE53BBD301863B7E@kit001.kaminario.local>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <E04C10E329E0CD40816C9C17AE53BBD301863B7E@kit001.kaminario.local>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eli Malul <eli.malul@kaminario.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Mar 01, 2011 at 03:04:56PM +0200, Eli Malul wrote:
> dm_malloc_aux do not allow memory allocation greater than 50000000.
 
That was to catch software bugs: it was a number bigger than ever
needed.  Change it if you need to, but I need stronger evidence
of the need for your particular way of doing things before
I'll change it in the upstream tree!

Alasdair

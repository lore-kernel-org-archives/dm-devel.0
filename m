From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: SCSI Sense patch
Date: Tue, 5 Sep 2006 16:10:05 +0100
Message-ID: <20060905151005.GM13859@agk.surrey.redhat.com>
References: <1156791189.26413.8.camel@cutter>
	<BAY114-F20C6936AC3F7E04C0C7C429D300@phx.gbl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <BAY114-F20C6936AC3F7E04C0C7C429D300@phx.gbl>
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

On Tue, Sep 05, 2006 at 01:59:51PM +0000, bart brooks wrote:
> I have been using for sometime Axboe?s SCSI sense data patches, which make 
> available the sense data in the bio end_io path and the dm-mpath?s 
> hw_handler. They work very nice.
> When will the show up in RHEL 4, in update 5 or later?
 
Unfortunately not because (1) upstream has decided not to use them but
to work towards an alternative way of achieving the same goal; and
(2) the patches involve a change to an important data structure that
might cause pre-compiled modules unconnected with device-mapper to cause
corruption.

Alasdair
-- 
agk@redhat.com

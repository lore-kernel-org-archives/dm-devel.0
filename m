From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: Re: mirroring: [patch 5 of 6] device failure tolerance
Date: Thu, 30 Jun 2005 13:10:04 -0500
Message-ID: <81d8053f082764c89f295d2defd3e16c@redhat.com>
References: <d459df3fa77e2c972d837f613a137de5@redhat.com>
	<200506301138.29354.kevcorry@us.ibm.com>
	<20050630175645.GG27078@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v622)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050630175645.GG27078@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kergon Alasdair <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


On Jun 30, 2005, at 12:56 PM, Alasdair G Kergon wrote:

> On Thu, Jun 30, 2005 at 11:38:28AM -0500, Kevin Corry wrote:
>> Any time a target's table-format or status-format changes, we also 
>> need to
>> increment that target's version number so user-space can figure out 
>> which
>> format to expect.
>
> Indeed, but I don't want version numbers updating till we know what
> sequence things will go upstream.
>
> BTW I've not seen a justification for breaking the existing format here
> yet as opposed to simply appending new data to the end of the status 
> line.
>

mirror_status first calls the log status function and then adds on to 
that.  If we want to do what you are proposing, we would move the log 
status function _after_ the DMEMIT's for mirror and it would only print 
out a char for each log device indicating status.  We would have to 
remember that STATUSTYPE_INFO and STATUSTYPE_TABLE would call the log 
status function at different place (one after it's own DMEMITs, the 
other before).

  brassow

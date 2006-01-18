From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: current status of mirroring in devel cycle?
Date: Wed, 18 Jan 2006 13:53:09 -0600
Message-ID: <20060118195309.GB14754@homer.msp.redhat.com>
References: <43CE918A.10805@photoresearchers.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <43CE918A.10805@photoresearchers.com>
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

On Wed, Jan 18, 2006 at 02:05:46PM -0500, Administrator wrote:
> Ideally I'd like to use pvmove to shift its 
> data onto other available PVs; with backups available I'm not sure I am as 
> concerned with "supported" so much as "stable".  

pvmove is believed to be pretty stable.

What is not stable yet is persistent mirroring using lvcreate -m.

Alasdair
-- 
agk@redhat.com

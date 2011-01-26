From: Joe Thornber <thornber@redhat.com>
Subject: Re: Announcement: new device-mapper thin provisioning
 target with infrastructure online for review
Date: Wed, 26 Jan 2011 08:29:32 +0000
Message-ID: <1296030572.15759.39.camel@ubuntu>
References: <1295972365.2936.77.camel@o>  <4D3F2D64.6060102@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4D3F2D64.6060102@cfl.rr.com>
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
Cc: heinzm@redhat.com
List-Id: dm-devel.ids

On Tue, 2011-01-25 at 15:07 -0500, Phillip Susi wrote:
> I assume that meta_dev can't, but can data_dev be shared between
> multiple thin-prov targets?

Nope, we're working on a target which does allow multiple
thinp/snapshots to be stored in the same metadata and data volumes. 

With the thinp target the idea is to allocate very little excess space
in the data volume, and allow dm-eventd to automatically do the resizing
as it grows (Alasdair's currently working on the userland tools).

- Joe

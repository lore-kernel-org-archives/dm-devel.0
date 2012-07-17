From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Load balancing reads on dmraid1 (and 01) arrays
Date: Tue, 17 Jul 2012 20:20:55 +0100
Message-ID: <20120717192055.GA5203@agk-dp.fab.redhat.com>
References: <CAJ3HoZ0ZsTv1D4vdnQct30gYbejHNvLJOTAaJXHJO8w7d199iA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAJ3HoZ0ZsTv1D4vdnQct30gYbejHNvLJOTAaJXHJO8w7d199iA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Robert Collins <robertc@robertcollins.net>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Is this guaranteed to improve performance for everyone?
If there are realistic configurations where it would make performance
worse, it needs to be configurable.

Hooking into extended versions of the multipath load balancing
modules (and adding a new proximity one) might indeed be another approach.

For upstream the PRINTKs would need to come out of course.
(We do have DMDEBUG though.)
If there are any necessary statistics that can't be gleaned with
'iostat' they could be published via blktrace or 'dmsetup status'.

Alasdair

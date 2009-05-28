From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: "multipath -l" not displaying all the paths if we
	have more than 3000 paths.
Date: Wed, 27 May 2009 21:18:25 -0400
Message-ID: <20090528011825.GB26270@mars.virtualiron.com>
References: <4F2CC79CDB05B844AEEA72F36255835403FD4ED5@bunker.inside.abhaisystems.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4F2CC79CDB05B844AEEA72F36255835403FD4ED5@bunker.inside.abhaisystems.com>
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

On Thu, May 21, 2009 at 11:38:17PM -0700, Harikrishnan Padidakul wrote:
> Hi All
> 
> I downloaded the latest multipath tool from git-clone http://kernel.org/pub/scm/linux/storage/multipath-tools/ <http://kernel.org/pub/scm/linux/storage/multipath-tools/.git> 
> 1) Tested with around 4000 paths(1000LUN exported to four port), and I observed multipath -l is not displaying all the paths.

You have to be more specific here. What kernel are you using?  If you
are using a RHEL5 or SLES10 based there is a race-condition where the
/sys/block devices are created without all the data entries populated
and multipathd can't get all the data from them.

And by
"not displaying all the paths", you mean that it did not have all of the
4 paths per LUN?? Or that you did not have 1000 multipath device maps?

> 2) And when we fail a path by disabling the port, all the path which are failed are not shown in multipath.

Do they show when you do "multipathd -k 'show paths'" as orphans?

Or do they show up if you run 'multipath' by itself?
> 
> Have we tested multipath with more than 3000 paths?
> 
> Thanks in advance.
> 
> Regards,
> Hari

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

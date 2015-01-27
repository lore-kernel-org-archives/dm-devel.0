From: Jan Kara <jack@suse.cz>
Subject: Re: [Lsf-pc] [LSF/MM ATTEND]: Hot spare module ? And
 Btrfs volume management without mount
Date: Tue, 27 Jan 2015 11:18:45 +0100
Message-ID: <20150127101845.GB13522@quack.suse.cz>
References: <54B8C174.4020802@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <54B8C174.4020802@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Anand Jain <Anand.Jain@oracle.com>
Cc: Chris Mason <clm@fb.com>, dm-devel@redhat.com, lsf-pc@lists.linux-foundation.org
List-Id: dm-devel.ids

  Hi,

  I'm replying somewhat late but when going through attend requests I was
wondering:

On Fri 16-01-15 15:44:52, Anand Jain wrote:
> 1.
>  Hot spare: is an important feature for the data centers. Hot spare
>  feature is common to MD, LVM and btrfs. And each of it locks in
>  resource to be used only at the event of failure. A system running more
>  than one type of VM like LVM and btrfs would end up having hot spares
>  assigned to each of the different VMs which looks system under
>  utilized.
> 
>  So to increase the utilization of disk hot spares with in the system,
>  a common kernel module with API could do a job better, with some
>  additional features.
> 
>  If needed I can provide a shot talk (just talk no slides) so to obtain
>  feedback and comments from the experts and have discussions.
  Do you have a concrete proposal or even patches for the module? Because I
guess the general idea is fine but the issue may be in how should we
exactly tie into LVM and btrfs. So without the details there won't be
much to discuss...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

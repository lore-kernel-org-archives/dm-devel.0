From: Joe Thornber <thornber@redhat.com>
Subject: Re: thin_check doesn't use data space map to open data
 mapping tree
Date: Tue, 7 Apr 2015 11:12:05 +0100
Message-ID: <20150407101204.GA10327@rh-vpn>
References: <CAAYit8RNtGwdSMWfD2ve8hS9iUPj+v49Gg+whnNp-WQHpB4GNw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAAYit8RNtGwdSMWfD2ve8hS9iUPj+v49Gg+whnNp-WQHpB4GNw@mail.gmail.com>
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
List-Id: dm-devel.ids

On Mon, Apr 06, 2015 at 10:18:45PM +0800, M.H. Tsai wrote:
> Hi All,
> 
> I found two doubtful points in thin-provisioning-tools,
> which might need your help to provide some opinions:

Firstly well done for digging through these tools.  I love it when
people take the time to read code.

> 1. thin_check doesn't open metadata and data space maps.
>    It uses the core space_map to open the mapping_tree,
>    instead of the data space map. Is that legal?
>    (Although block_time_ref_counter was never used during tree traversal)

Is it legal?  Yes, walking the mappings doesn't require any
use of the space map.

But it does highlight the fact that I'm not checking the space maps
correctness currently.  The first release of the tools _did_ do this,
but it was ommitted when I did a big tidy up.  There is a branch with
some work for this area that I need to merge in.

> 2. Class mapping_tree_detail::ll_damage_visitor should not be used to
> traverse
>    a single_mapping_tree. This class was designed for two-level data
> mapping tree,
>    or the top-level data mapping tree (i.e., mapping_tree and dev_tree
> types).
>    It generates missing_devices while visiting a damage with
> zero-length-path,
>    which is not semantically suitable for single_mapping_tree.

Yep, I think you're right.  Thanks.

- Joe

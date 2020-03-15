From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 4/4] libmpathpersist: ABI change: limit
 data-in/out size to 8192 bytes
Date: Sun, 15 Mar 2020 21:45:58 +0100
Message-ID: <a561b7a338a2941b4929742e10016bfd59330bc8.camel@suse.com>
References: <20200306230605.3473-1-mwilck@suse.com>
	<20200306230605.3473-5-mwilck@suse.com>
	<20200315001935.GU30153@octiron.msp.redhat.com>
	<78489690d69561da912f944ef072f18900e679f5.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <78489690d69561da912f944ef072f18900e679f5.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, David Bond <dbond@suse.com>
List-Id: dm-devel.ids

On Sun, 2020-03-15 at 01:27 +0100, Martin Wilck wrote:
> 
> A program written against the old API might assume that the length of
> private_buffer was MPATH_MAX_PARAM_LEN, and call e.g.
> memset(private_buffer, 0, MPATH_MAX_PARAM_LEN), overwriting
> num_transportid.

And programs compiled against old headers would obviously use the
wrong offsets for num_transportids and trnptid_list.

Similar for struct print_fulldescr_list.descriptors.

So I this does indeed break the ABI. Perhaps we shouldn't apply this
without implementing clean so numbering.

Regards
Martin

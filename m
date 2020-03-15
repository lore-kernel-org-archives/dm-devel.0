From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 4/4] libmpathpersist: ABI change: limit
 data-in/out size to 8192 bytes
Date: Sun, 15 Mar 2020 01:27:49 +0100
Message-ID: <78489690d69561da912f944ef072f18900e679f5.camel@suse.com>
References: <20200306230605.3473-1-mwilck@suse.com>
	<20200306230605.3473-5-mwilck@suse.com>
	<20200315001935.GU30153@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200315001935.GU30153@octiron.msp.redhat.com>
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

On Sat, 2020-03-14 at 19:19 -0500, Benjamin Marzinski wrote:
> On Sat, Mar 07, 2020 at 12:06:05AM +0100, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > Make sure that data structures used for PERSISTENT RESERVE IN/OUT
> > fit into 8k buffers.
> > 
> > This patch breaks the libmpathpersist ABI.
> > 
> 
> I'm not super worried about this.  I don't really see a way for users
> to
> hurt themselves because of this change, without making some pretty
> odd
> assumptions.  Am I missing something?

I found this:

struct prout_param_descriptor {	
	uint8_t	 key[8];
	uint8_t	 sa_key[8];
[...]
	uint8_t  private_buffer[MPATH_MAX_PARAM_LEN - 24];
	uint32_t num_transportid;
	struct transportid *trnptid_list[];
};

A program written against the old API might assume that the length of
private_buffer was MPATH_MAX_PARAM_LEN, and call e.g.
memset(private_buffer, 0, MPATH_MAX_PARAM_LEN), overwriting
num_transportid.

The same could happen if a program compiled against the new API was
linked against the old. In that case, the overwrite would happen in 
format_transportids().

Martin

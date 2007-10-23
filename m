From: Chip Coldwell <coldwell@redhat.com>
Subject: Re: Explicit ALUA handling
Date: Tue, 23 Oct 2007 15:57:16 -0400 (EDT)
Message-ID: <alpine.LRH.0.9999.0710231554090.16194@bogart.boston.redhat.com>
References: <E88AE5BB44F80746A49345D6CC73334005D8B3A3@CORPUSMX30A.corp.emc.com>
	<471D8E55.5040109@suse.de>
	<alpine.LRH.0.9999.0710230914080.15410@bogart.boston.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.0.9999.0710230914080.15410@bogart.boston.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, 23 Oct 2007, Chip Coldwell wrote:

> On Tue, 23 Oct 2007, Hannes Reinecke wrote:
> 
> > Hi Chip,
> > 
> > the folks from EMC have forwarded your request to me.
> > You already might have seen the initial posting to
> > dm-devel, so there's at least some code to get a start.
> > 
> > Currently I'm working on implementing a generic
> > command queue framework for hardware handler, so that
> > the rdac and alua handler don't have to implement their
> > own handling but rather can use some generic functions.
> > 
> > So, how can I help you?
> 
> Well, you just did.  I think I found your posting here
> 
> https://www.redhat.com/archives/dm-devel/2007-October/msg00033.html
> 
> So now I will take a little time to read and understand the code.
> Then perhaps we should take our conversation over to the dm-devel
> mailing list.

Apropos this

+/*
+ * Evaluate SET TARGET GROUP STATES
+ *
+ * We only have to test here if we should resubmit the command;
+ * any other error is assumed as a failure.
+ * Maybe we should analyze the sensebuffer here, too.
+ */
+static void alua_stpg(struct alua_handler *h, enum tpgs_state n)
+{
+	unsigned error;
+	int retry = 5;
+
+ retry:
+	error = submit_stpg(h);
+	switch(host_byte(error)) {
+	case DID_BUS_BUSY:
+		if (!retry)
+			break;
+		retry++;
+	case DID_REQUEUE:
+	case DID_IMM_RETRY:
+		goto retry;
+	}

Didn't you mean to use "retry--" instead of "retry++"?  Otherwise, I
think you'll get a few more retries than you planned.

Also, I note that the tpgs_state parameter isn't used; submit_stpg
will always try to put the port group into the OPTIMIZED state.  Is
that the intention?

Chip

-- 
Charles M. "Chip" Coldwell
Senior Software Engineer
Red Hat, Inc
978-392-2426

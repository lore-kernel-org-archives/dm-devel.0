From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2] dm dust: convert documentation to ReST
Date: Thu, 10 Oct 2019 11:37:30 -0600
Message-ID: <20191010113730.3f0da042@lwn.net>
References: <1570469089-31554-1-git-send-email-bgurney@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1570469089-31554-1-git-send-email-bgurney@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bryan Gurney <bgurney@redhat.com>
Cc: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com, linux-doc@vger.kernel.org
List-Id: dm-devel.ids

On Mon,  7 Oct 2019 13:24:49 -0400
Bryan Gurney <bgurney@redhat.com> wrote:

> Convert the dm-dust documentation to ReST formatting, using literal
> blocks for all of the shell command, shell output, and log output
> examples.
> 
> Add dm-dust to index.rst.
> 
> Additionally, fix an annotation in the "querying for specific bad
> blocks" section, on the "queryblock ... not found in badblocklist"
> example, to properly state that the message appears when a given
> block is not found.
> 
> Signed-off-by: Bryan Gurney <bgurney@redhat.com>

Applied, thanks.

jon

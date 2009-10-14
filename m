From: Ryo Tsuruta <ryov@valinux.co.jp>,
	Ryo Tsuruta <ryov@valinux.co.jp>
Subject: IO controller Mini-Summit 2009
Date: Wed, 14 Oct 2009 21:24:44 +0900 (JST)
Message-ID: <20091014.212444.179938286.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com
List-Id: dm-devel.ids

Hello,

I have summarized the topics for the IO controller mini-summit and
written the ideas seen in the mailing list.

- The place where IO controller should be implemented
  - Block layer in conjunction with the IO scheduler
  - Common layer right above the IO scheduler
  - CFQ enhancement.
  - Both block and common layer, users can select whichever controller
    they want.
  - VFS layer

- What kind of bandwidth control policies are needed?
  - Proportional weight
  - Enforcing upper limit
  - Minimum bandwidth guarantee

- How to handle buffered writes?
  - Add dirt-ratio in the memory controller
  - Add bufferred-write-cgroup to track buffered writebacks
  - A per group per bdi pdflush threads

- Who should be charged for swap activity?
  - who requests a page.
  - who has a page.
  - All swap activities are charged to the root group.

And I would also like to discuss about the followings.

- Extensions of struct bio
  - Make a bio point to the io_context of a process which creates the
    I/O request. This allows to pass the IO scheduling class and
    priority information to IO controller even if the IO is submitted
    by another process which does not create the request, such as a
    worker thread.
  - Add a new flag to struct bio to identify the bio as urgent. This
    gives IO controller a chance to handle the bio as high
    priority. This flag should be set if the bio is created for the
    page-out operation. 

- Common test methods to verify the functionality of IO controller.

Please give me comments and suggestions. I may be missing or
misunderstanding something.

Thanks,
Ryo Tsuruta

From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: replace FSF address with a www
	pointer
Date: Sat, 10 Mar 2018 21:50:02 +0100
Message-ID: <20180310205002.3318-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Less prone to future modifications, and new FSF licences
point exactly to this url: <http://www.gnu.org/licenses/>.

First clean up was done in 5619a39c433ac3d10a88079593cec1aa6472cbeb

Cc: Martin Wilck <mwilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/dm-generic.c   | 4 +---
 libmultipath/dm-generic.h   | 4 +---
 libmultipath/foreign.c      | 4 +---
 libmultipath/foreign.h      | 4 +---
 libmultipath/foreign/nvme.c | 4 +---
 libmultipath/generic.c      | 4 +---
 libmultipath/generic.h      | 4 +---
 7 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/libmultipath/dm-generic.c b/libmultipath/dm-generic.c
index bdc9ca0..d752991 100644
--- a/libmultipath/dm-generic.c
+++ b/libmultipath/dm-generic.c
@@ -12,9 +12,7 @@
   GNU General Public License for more details.
 
   You should have received a copy of the GNU General Public License
-  along with this program; if not, write to the Free Software
-  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
-  USA.
+  along with this program.  If not, see <https://www.gnu.org/licenses/>.
  */
 
 #include <stdint.h>
diff --git a/libmultipath/dm-generic.h b/libmultipath/dm-generic.h
index 5d59724..986429f 100644
--- a/libmultipath/dm-generic.h
+++ b/libmultipath/dm-generic.h
@@ -12,9 +12,7 @@
   GNU General Public License for more details.
 
   You should have received a copy of the GNU General Public License
-  along with this program; if not, write to the Free Software
-  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
-  USA.
+  along with this program.  If not, see <https://www.gnu.org/licenses/>.
  */
 #ifndef _DM_GENERIC_H
 #define _DM_GENERIC_H
diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
index 7217184..80b399b 100644
--- a/libmultipath/foreign.c
+++ b/libmultipath/foreign.c
@@ -12,9 +12,7 @@
   GNU General Public License for more details.
 
   You should have received a copy of the GNU General Public License
-  along with this program; if not, write to the Free Software
-  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
-  USA.
+  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
 
 #include <sys/sysmacros.h>
diff --git a/libmultipath/foreign.h b/libmultipath/foreign.h
index 973f368..697f12f 100644
--- a/libmultipath/foreign.h
+++ b/libmultipath/foreign.h
@@ -12,9 +12,7 @@
   GNU General Public License for more details.
 
   You should have received a copy of the GNU General Public License
-  along with this program; if not, write to the Free Software
-  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
-  USA.
+  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
 #ifndef _FOREIGN_H
 #define _FOREIGN_H
diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index 235f75d..280b6bd 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -12,9 +12,7 @@
   GNU General Public License for more details.
 
   You should have received a copy of the GNU General Public License
-  along with this program; if not, write to the Free Software
-  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
-  USA.
+  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
 
 #include <sys/sysmacros.h>
diff --git a/libmultipath/generic.c b/libmultipath/generic.c
index 6f7a2cd..0d1e632 100644
--- a/libmultipath/generic.c
+++ b/libmultipath/generic.c
@@ -12,9 +12,7 @@
   GNU General Public License for more details.
 
   You should have received a copy of the GNU General Public License
-  along with this program; if not, write to the Free Software
-  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
-  USA.
+  along with this program.  If not, see <https://www.gnu.org/licenses/>.
  */
 
 
diff --git a/libmultipath/generic.h b/libmultipath/generic.h
index 7f7fe66..6346ffe 100644
--- a/libmultipath/generic.h
+++ b/libmultipath/generic.h
@@ -12,9 +12,7 @@
   GNU General Public License for more details.
 
   You should have received a copy of the GNU General Public License
-  along with this program; if not, write to the Free Software
-  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
-  USA.
+  along with this program.  If not, see <https://www.gnu.org/licenses/>.
  */
 #ifndef _GENERIC_H
 #define _GENERIC_H
-- 
2.14.3

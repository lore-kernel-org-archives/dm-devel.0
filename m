From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/2] multipath-tools: replace FSF address with a
	www pointer
Date: Thu, 30 Jun 2016 16:39:52 +0200
Message-ID: <1467297593-20514-2-git-send-email-xose.vazquez@gmail.com>
References: <1467297593-20514-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467297593-20514-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

less prone to future modifications, new FSF licences point
exactly to this url: <http://www.gnu.org/licenses/>

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 kpartx/dasd.c                     | 4 +---
 kpartx/dasd.h                     | 4 +---
 kpartx/efi.h                      | 3 +--
 kpartx/gpt.c                      | 3 +--
 kpartx/gpt.h                      | 3 +--
 libmpathcmd/mpath_cmd.h           | 6 ++----
 libmultipath/checkers/cciss_tur.c | 6 +-----
 libmultipath/sysfs.c              | 3 +--
 libmultipath/uevent.c             | 3 +--
 9 files changed, 10 insertions(+), 25 deletions(-)

diff --git a/kpartx/dasd.c b/kpartx/dasd.c
index ef13709..5342184 100644
--- a/kpartx/dasd.c
+++ b/kpartx/dasd.c
@@ -19,9 +19,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307,
- * USA.
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <stdio.h>
diff --git a/kpartx/dasd.h b/kpartx/dasd.h
index 1f6c99f..2779366 100644
--- a/kpartx/dasd.h
+++ b/kpartx/dasd.h
@@ -19,9 +19,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307,
- * USA.
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #ifndef _DASD_H
diff --git a/kpartx/efi.h b/kpartx/efi.h
index 1cbd961..c66508e 100644
--- a/kpartx/efi.h
+++ b/kpartx/efi.h
@@ -14,8 +14,7 @@
     GNU General Public License for more details.
 
     You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+    along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #ifndef EFI_H
diff --git a/kpartx/gpt.c b/kpartx/gpt.c
index ee6170b..416eac8 100644
--- a/kpartx/gpt.c
+++ b/kpartx/gpt.c
@@ -18,8 +18,7 @@
     GNU General Public License for more details.
 
     You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
 
 #define _FILE_OFFSET_BITS 64
diff --git a/kpartx/gpt.h b/kpartx/gpt.h
index 1f35fa0..515306e 100644
--- a/kpartx/gpt.h
+++ b/kpartx/gpt.h
@@ -18,8 +18,7 @@
     GNU General Public License for more details.
 
     You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
 
 #ifndef _GPT_H
diff --git a/libmpathcmd/mpath_cmd.h b/libmpathcmd/mpath_cmd.h
index f33f000..92382e2 100644
--- a/libmpathcmd/mpath_cmd.h
+++ b/libmpathcmd/mpath_cmd.h
@@ -13,10 +13,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU Lesser General Public License for more details.
  *
- * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301,
- * USA.
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #ifndef LIB_MPATH_CMD_H
diff --git a/libmultipath/checkers/cciss_tur.c b/libmultipath/checkers/cciss_tur.c
index 4c26901..81500dc 100644
--- a/libmultipath/checkers/cciss_tur.c
+++ b/libmultipath/checkers/cciss_tur.c
@@ -14,11 +14,7 @@
  * for more details.                                                         *
  *                                                                           *
  * You should have received a copy of the GNU General Public License along   *
- * with this program; if not, write to the Free Software Foundation, Inc.,   *
- * 675 Mass Ave, Cambridge, MA 02139, USA.                                   *
- *                                                                           *
- * The copy of the GNU General Public License is available at                *
- * /opt/hp/HPDMmultipath-tool directoy                                       *
+ * with this program.  If not, see <http://www.gnu.org/licenses/>.           *
  *                                                                           *
  *****************************************************************************
 */
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 2c0b591..9cf0311 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -11,8 +11,7 @@
  *	General Public License for more details.
  *
  *	You should have received a copy of the GNU General Public License along
- *	with this program; if not, write to the Free Software Foundation, Inc.,
- *	51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *	with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  */
 
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index ff4bc86..ca41d35 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -18,8 +18,7 @@
  *	General Public License for more details.
  *
  *	You should have received a copy of the GNU General Public License along
- *	with this program; if not, write to the Free Software Foundation, Inc.,
- *	675 Mass Ave, Cambridge, MA 02139, USA.
+ *	with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  */
 
-- 
2.7.4
